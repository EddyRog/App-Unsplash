//
// SearchPhotosServiceAPIImpl.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

protocol SearchPhotosServiceAPI {
    func searchPhotos(with request: String, completion: @escaping ([Response]) -> Void)
}

class SearchPhotosServiceAPIImpl: SearchPhotosServiceAPI {
    var session: URLSession = URLSession.shared

    func searchPhotos(with request: String, completion: @escaping ([Response]) -> Void) {
        // make url
        // make urlRequest
        // make call
        // send back the response
        do {
            let url = try self.makeURL(with: request)
            let urlRequest = try makeURLRequest(url: url)

            session.dataTask(with: urlRequest, completionHandler: { data, _, _ in
                guard let unwData = data else { return completion([Response]()) }
                guard let dataParsed = try? self.parseResponse(data: unwData) else {
					print("return")
                    return completion([Response]())
                }
                // send back data Decoded
                completion(dataParsed)
            }).resume()
        } catch {
            completion([Response]())
        }
    }

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

    func parseResponse(data: Data) throws -> [Response] {
        let decoder = JSONDecoder()
        var responses = [Response]()

        do {
            let responseData = try decoder.decode(UnsplashObjc.self, from: data)

            responseData.photos.results.forEach { result in

                let response = Response(description: result.resultDescription)
                responses.append(response)
            }

            return responses
        } catch {

            throw ServiceError.dataParse
        }
    }
}

