//
// ParserSearchPhotos.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

class ParserSearchPhotos {
    var decoder: JSONDecoder? = JSONDecoder()

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



struct Photo {
    var description: String
    var picture: String
}
// ==================
// MARK: - DataStructure
// ==================

/*
struct Photo: Codable {
    var id: [Int]
    var attribute: [Attribute]
}
struct Attribute: Codable {
    // var nameid0: String?    // Ancienne key qui match au JSON
    var nameID0: String? // Nouvelle Key qu'on veux dans le code

    // Structure pour Nouvelle Key qu'on veux dans le code
    enum CodingKeys: String, CodingKey {
        // case Substitution = realNameInJson
        case nameID0 = "nameid0"
    }
}
*/
