//
// Models.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

struct Photo: Equatable {
    var description: String?

    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.description == rhs.description
    }
}


enum SearchPhotos {
//    enum Create { }
//    enum UpdatePhotos { }
//    enum DeletePhotos  { }
    enum FetchPhotos {
        struct Request {
            var query: String
        }
        struct Response {
            var photos: [Photo]
        }
        struct ViewModel: Equatable {
            struct DisplayedPhoto: Equatable {
                var description: String

                static func == (lhs: SearchPhotos.FetchPhotos.ViewModel.DisplayedPhoto, rhs: SearchPhotos.FetchPhotos.ViewModel.DisplayedPhoto) -> Bool {
                    return lhs.description == rhs.description
                }
            }
            var displayedPhotos: [DisplayedPhoto]

            static func == (lhs: SearchPhotos.FetchPhotos.ViewModel, rhs: SearchPhotos.FetchPhotos.ViewModel) -> Bool {
                return lhs.displayedPhotos == rhs.displayedPhotos
            }
        }
    }
}

// ==================
// MARK: - Transfer object
// ==================
struct Response: Equatable {
    var description: String
    var urlSmall: String?
    var id: String?
}
struct ViewModel: Equatable {
    var description: String
    var urlSmall: String?
}

// ==================
// MARK: - Error
// ==================
enum ServiceError: Error {
    case urlError
    case dataParse
}


// ==================
// MARK: - Decodable
// ==================
struct UnsplashObjc: Codable {
    var photos: Photos
}

struct Photos: Codable {
    var results: [Result]
}

struct Result: Codable {
    var resultDescription: String
    var urls: PictureUrls
    var id: String

    // Re map the keys
    enum CodingKeys: String, CodingKey {
        case resultDescription = "description"
        case urls
        case id
    }

    // DefaultValue
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        resultDescription = try container.decodeIfPresent(String.self, forKey: .resultDescription) ?? "😖 NO DESCRIPTION"
        urls = try container.decodeIfPresent(PictureUrls.self, forKey: .urls) ?? PictureUrls(small: "")
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? "😖 NO ID"
    }
}

struct PictureUrls: Codable {
    var small: String
}
