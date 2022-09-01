//
// SearchPhotosWorker.swift
// App-Unsplash
// Created in 2022
// Swift 5.0

import Foundation

protocol PhotosWorkable {
    func retrievePhotos(withRequest request: String, complectionRetrieve: @escaping ([Photo]) -> Void)
    func retrievePhoto(withID request: String, completionRetrieve: @escaping (Photo?) -> Void)
    func retrievePhotosOnNextPage(withRequest request: SearchPhotos.RetrievePhotos.Request, completionRetrieve: @escaping ([Photo]) -> Void)
}

class PhotosWorker {
    var session: URLSession = URLSession.shared

    func makeURLRequest(withRequest unsplashURL: UnsplashURL) throws -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constant.URL.scheme
        urlComponents.host = Constant.URL.host

        urlComponents.queryItems = [
            URLQueryItem(name: Constant.URL.urlQuery.cliendID.rawValue.key, value: Constant.URL.urlQuery.cliendID.rawValue.value)
        ]

        switch unsplashURL {
        case .urlID(let value):
            urlComponents.path = "/photos/\(value)"

        case .urlRequest(let value):
            urlComponents.path = "/search"

            let urlQueryItem = URLQueryItem(name: "query", value: value)
            urlComponents.queryItems?.append(urlQueryItem)

        case .nextPage(let request, let currentPage):
            urlComponents.path = "/search"

            // check current
            var actualPage = "0"
            actualPage = getNextPage(currentPage, actualPage)

            let urlQueryItemQuery = URLQueryItem(name: "query", value: request)
            let urlQueryItemPage = URLQueryItem(name: Constant.URL.urlQuery.page.rawValue.key, value: actualPage)

            urlComponents.queryItems?.append(urlQueryItemQuery)
            urlComponents.queryItems?.append(urlQueryItemPage)

            // check limite page
            // TODO: ❎ check limit page ❎
        }

        guard let urlString = urlComponents.url?.absoluteString else { throw ServiceError.urlError }
        guard let url = URL(string: urlString) else { throw ServiceError.urlError }
        return URLRequest(url: url)
    }
    func getNextPage(_ currentPage: String?, _ actualPage: String) -> String {
    let defaultPageValue = "2"
    guard let unwCurrentPage = currentPage else { return defaultPageValue }
    guard let valueCurrentPage = Int(unwCurrentPage) else { return defaultPageValue }

    // TODO: ❎ Test if not reach mac page ❎

    if valueCurrentPage < 2 {
        return defaultPageValue
    }
    return String(valueCurrentPage + 1)
}

    func parseResponse(data: Data) throws -> SearchPhotos.RetrievePhotos.Response {
        let decoder = JSONDecoder()
        var response = SearchPhotos.RetrievePhotos.Response(photos: [Photo]())
        do {
            let responseData = try decoder.decode(UnsplashObjc.self, from: data)

            responseData.photos.results.forEach { result in
                let photoID = result.id
                let description = result.resultDescription
                let urlsmallImage = result.urls.small
                let userName = result.user.name

                let photo = Photo(
                    urlsmallImage: urlsmallImage,
                    photoID: photoID,
                    description: description,
                    userName: userName)
                response.photos.append(photo)
            }

            return response
        } catch {
            throw ServiceError.dataParse
        }
    }
    func parseResponse(dataPhotoID: Data) throws -> ShowPhoto.RetrievePhoto.Response {
        let decoder: JSONDecoder = JSONDecoder()
        var response: ShowPhoto.RetrievePhoto.Response = .init(photo: nil)

        do {
            let responseData = try decoder.decode(Result.self, from: dataPhotoID)

            let smallImage = responseData.urls.small
            let photoID = responseData.id
            let description = responseData.resultDescription
            let userName = responseData.user.name

            response.photo = Photo(
                urlsmallImage: smallImage,
                photoID: photoID,
                description: description,
                userName: userName
            )
            return response

        } catch {
            throw ServiceError.dataParse
        }
    }
}

extension PhotosWorker: PhotosWorkable {

    func retrievePhotos(withRequest request: String, complectionRetrieve: @escaping ([Photo]) -> Void) {
        let emptyPhotos: [Photo] = [Photo]()
        do {
            let urlRequest = try makeURLRequest(withRequest: .urlRequest(request))

            session.dataTask(with: urlRequest) { data, _, _ in
                guard let unwData = data else { complectionRetrieve(emptyPhotos); return }
                guard let unwDataParsed = try? self.parseResponse(data: unwData) else { complectionRetrieve(emptyPhotos); return }

                    complectionRetrieve(unwDataParsed.photos) // send back data Decoded
            }.resume()

        } catch {
            complectionRetrieve(emptyPhotos) // send it back
        }
    }
    func retrievePhoto(withID photoID: String, completionRetrieve: @escaping (Photo?) -> Void) {
        do {
            let urlrequest = try makeURLRequest(withRequest: .urlID(photoID))
            session.dataTask(with: urlrequest) { data, _, _ in

                guard let unwData = data else { completionRetrieve(nil); return }
                guard let unwDataParsed = try? self.parseResponse(dataPhotoID: unwData) else { completionRetrieve(nil); return }

                completionRetrieve(unwDataParsed.photo)

            }.resume()

        } catch {
            completionRetrieve(nil)
        }
    }
    func retrievePhotosOnNextPage(withRequest request: SearchPhotos.RetrievePhotos.Request, completionRetrieve: @escaping ([Photo]) -> Void) {
        do {
            let urlRequest = try makeURLRequest(withRequest: .nextPage(request: request.query, currentPage: request.currentPage))
            session.dataTask(with: urlRequest) { data, _, _ in
                guard let unwData = data else { return }
                guard let unwDataParsed = try? self.parseResponse(data: unwData) else { return }
                // avoid lag to wait
                DispatchQueue.main.async {
                	debugPrint("dee L\(#line) 🏵 -------> DISP")
                    completionRetrieve(unwDataParsed.photos) // send back data Decoded
                }

            }.resume()
        } catch {
            	completionRetrieve([Photo]())
        }
    }
}

enum UnsplashURL {
    case urlID(String)
    case urlRequest(String)
    case nextPage(request: String, currentPage: String?)
}
