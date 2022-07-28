//
// SearchPhotosServiceAPIImpl.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

class PhotosServiceAPI {

    var session: URLSession = URLSession.shared

    func makeURLRequest(with unsplashURL: UnsplashURL) throws -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "a76ebbad189e7f2ae725980590e4c520a525e1db029aa4cea87b44383c8a1ec4")
        ]

        switch unsplashURL {
            case .urlID(let value):
                urlComponents.path = "/photos/\(value)"

            case .urlRequest(let value):
                urlComponents.path = "/search"

                let urlQueryItem = URLQueryItem(name: "query", value: value)
                urlComponents.queryItems?.append(urlQueryItem)
        }


        guard let urlString = urlComponents.url?.absoluteString else { throw ServiceError.urlError }
        guard let url = URL(string: urlString) else { throw ServiceError.urlError }
        return URLRequest(url: url)
    }
    func parseResponse(data: Data) throws -> SearchPhotos.FetchPhotos.Response {
        let decoder = JSONDecoder()
        var responses = SearchPhotos.FetchPhotos.Response(photos: [Photo]())

        do {
            let responseData = try decoder.decode(UnsplashObjc.self, from: data)

            responseData.photos.results.forEach { result in

                //                let response = Response(
                //                    description: result.resultDescription,
                //                    urlSmall: result.urls.small,
                //                    id: result.id
                //                )
                let photo = Photo(
                    description: result.resultDescription
                )
                responses.photos.append(photo)
                //                responses.append(response)
            }

            return responses
        } catch {

            throw ServiceError.dataParse
        }
    }
    func parseResponseForPhotoID(data: Data) throws -> ShowPhoto.FetchBook.Response {
		let decoder = JSONDecoder()
        var response: ShowPhoto.FetchBook.Response = .init(photo: Photo())
        do {
            let responseData = try decoder.decode(Result.self, from: data)
            let description = responseData.resultDescription
            response.photo.description = description
            return response
        } catch {
            throw ServiceError.dataParse
        }
    }
}

extension PhotosServiceAPI: PhotosServiceProtocol {

    func fetchPhotos(withRequest request: String, completionHandler: @escaping ([Photo]) -> Void) {
        do {
            let urlRequest = try makeURLRequest(with: .urlRequest(request))

            session.dataTask(with: urlRequest) { data, _, _ in
                guard let unwData = data else { completionHandler([Photo]()); return  }
                guard let dataParsed = try? self.parseResponse(data: unwData) else { completionHandler([Photo]()); return }
                // send back data Decoded
                completionHandler(dataParsed.photos)
            }.resume()
        } catch {
            completionHandler([Photo]())
        }
    }
    func fetchPhoto(withID: String, completionHandler: @escaping (Photo) -> Void) {
        do {
            let urlRequest = try makeURLRequest(with: .urlID(withID))

            session.dataTask(with: urlRequest) { data, _, _ in
                guard let unwdData = data else { completionHandler(Photo()); return }
                guard let response = try? self.parseResponseForPhotoID(data: unwdData) else { completionHandler(Photo()); return }
                completionHandler(response.photo)

            }.resume()
        } catch {
			completionHandler(Photo())
        }
    }
}

enum UnsplashURL {
    case urlID(String)
    case urlRequest(String)
}
