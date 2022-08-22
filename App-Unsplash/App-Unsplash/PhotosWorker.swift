//
// SearchPhotosWorker.swift
// App-Unsplash
// Created in 2022
// Swift 5.0

import Foundation
protocol PhotosWorkerLogic {
    func retrievePhotos(withRequest request: String, complectionRetrieve: @escaping ([Photo]) -> Void )
}

class PhotosWorker: PhotosWorkerLogic {

    var session: URLSession = URLSession.shared

    func makeURLRequest(withRequest unsplashURL: UnsplashURL) throws -> URLRequest {
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
        var response = SearchPhotos.FetchPhotos.Response(photos: [Photo]())
        do {
            let responseData = try decoder.decode(UnsplashObjc.self, from: data)

            responseData.photos.results.forEach { result in
                let photo = Photo(description: result.resultDescription)
                response.photos.append(photo)
            }

            return response
        } catch {
            throw ServiceError.dataParse
        }
    }

    func retrievePhotos(withRequest request: String, complectionRetrieve: @escaping ([Photo]) -> Void ) {
        let emptyPhotos: [Photo] = [Photo]()
        // retrieve data with apple classe
        do {
            let urlRequest = try makeURLRequest(withRequest: .urlRequest(request))

            session.dataTask(with: urlRequest) { data, _, _ in
                guard let unwData = data else { complectionRetrieve(emptyPhotos); return  }
                guard let dataParsed = try? self.parseResponse(data: unwData) else { complectionRetrieve(emptyPhotos); return }

                complectionRetrieve(dataParsed.photos) // send back data Decoded
            }.resume()
        } catch {
            complectionRetrieve(emptyPhotos) // send it back
        }
    }
}

enum UnsplashURL {
    case urlID(String)
    case urlRequest(String)
}
