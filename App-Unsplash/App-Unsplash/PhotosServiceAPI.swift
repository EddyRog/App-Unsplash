//
// SearchPhotosServiceAPIImpl.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

class PhotosServiceAPI {

    var session: URLSession = URLSession.shared

    func makeURL(with request: String) throws -> URL {
        let apiKey = "client_id=a76ebbad189e7f2ae725980590e4c520a525e1db029aa4cea87b44383c8a1ec4"
        let urlProtocol = "https"
        let urlBase = "api.unsplash.com"
        let stringUrl = "\(urlProtocol)://\(urlBase)/search/?query=\(request)&\(apiKey)"
        guard let url = URL(string: stringUrl) else {
            throw ServiceError.urlError
        }
        return url
    }

    func makeURLRequest(url: URL) throws -> URLRequest {
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
}
//PhotosStoreProtocol
extension PhotosServiceAPI: PhotosServiceProtocol {

    func fetchPhoto(withID: String, completionHandler: @escaping (Photo) -> Void) {
        // FIXME: ⚠️ FakeDataPass ⚠️
//        completionHandler
        // send back
    }

    func fetchPhotos(withRequest request: String, completionHandler: @escaping ([Photo]) -> Void) {
        do {
            let url = try self.makeURL(with: request)
            let urlRequest = try makeURLRequest(url: url)

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
}
