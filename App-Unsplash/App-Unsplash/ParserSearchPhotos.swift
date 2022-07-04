//
// ParserSearchPhotos.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

protocol ParserSearchPhotos {
    var decoder: JSONDecoder? {get set}
    func parse(with jsonData: Data) -> CodableParserSearchPhotos?
    func extract(with alldataDecoded: CodableParserSearchPhotos) -> [Photo]
}

class ParserSearchPhotosImpl: ParserSearchPhotos {
    var decoder: JSONDecoder? = JSONDecoder()
    var clientID: String = ""

    func parse(with jsonData: Data) -> CodableParserSearchPhotos? {
        guard let codableParserSearchPhotos = try? decoder?.decode(CodableParserSearchPhotos.self, from: jsonData) else {
            return nil
        }

		return codableParserSearchPhotos
    }

    func extract(with alldataDecoded: CodableParserSearchPhotos) -> [Photo] {
        var photos: [Photo] = []
        alldataDecoded.photos?.results.forEach { codableResult  in
            // --- extract data.
            let description = codableResult.description ?? ""
            let picture = codableResult.urls?.thumb ?? ""

            // --- make photo.
            let photo = Photo(description: description, picture: picture)

            // --- add it.
            photos.append(photo)
        }
        return photos
    }

    func buildUrlQuery(with request: String) -> String {
        // init
        let urlRequestObjc = URLRequestObjc(scheme: "https",
                       host: "api.unsplash.com",
                       path: "/search/")

        return urlRequestObjc.build(request: request)
    }
}

struct CodableParserSearchPhotos: Codable, Equatable {
    var photos: CodablePhotos?

    static func == (lhs: CodableParserSearchPhotos, rhs: CodableParserSearchPhotos) -> Bool {
        return lhs.photos == rhs.photos
    }
}
struct CodablePhotos: Codable, Equatable {
    var results: [CodableResult]

    static func == (lhs: CodablePhotos, rhs: CodablePhotos) -> Bool {
        return lhs.results == rhs.results
    }
}
struct CodableResult: Codable, Equatable {
    var description: String?
    var urls: CodableUrl?

    static func == (lhs: CodableResult, rhs: CodableResult) -> Bool {
        return lhs.description == rhs.description && lhs.urls == rhs.urls
    }
}
struct CodableUrl: Codable, Equatable {
    var thumb: String?

    static func == (lhs: CodableUrl, rhs: CodableUrl) -> Bool {
        return lhs.thumb == rhs.thumb
    }
}


/** Create url request*/
struct URLRequestObjc {
    var scheme: String
    var host: String
    var path: String
	var keyAPI: String

    internal init(scheme: String, host: String, path: String, keyPath: String = "") {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.keyAPI = keyPath
    }

    func build(request: String = "") -> String {
        var component = URLComponents()
        component.scheme = self.scheme
        component.host = self.host
        component.path = self.path
        // swiftlint:disable trailing_comma
        component.queryItems = [
            URLQueryItem(name: "query", value: request),
            URLQueryItem(name: "client_id", value: keyAPI),
        ]
//        URLQueryItem(name: "client_id", value: "a76ebbad189e7f2ae725980590e4c520a525e1db029aa4cea87b44383c8a1ec4"),

        return component.string ?? "-"
    }
}
