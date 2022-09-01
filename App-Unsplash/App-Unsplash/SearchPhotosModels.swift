//
// Models.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

enum SearchPhotos {
//    enum Create { }
//    enum UpdatePhotos { }
//    enum DeletePhotos  { }
    enum RetrievePhotos {
        struct Request {
            var query: String
            var currentPage: String?
        }
        struct Response: Equatable {
            var photos: [Photo]

            static func == (lhs: SearchPhotos.RetrievePhotos.Response, rhs: SearchPhotos.RetrievePhotos.Response) -> Bool {
                return lhs.photos == rhs.photos
            }
        }
        struct ViewModel: Equatable {
            struct DisplayedPhoto: Equatable {
                var urlsmallImage: String
                var photoID: String
                var description: String

                static func == (lhs: SearchPhotos.RetrievePhotos.ViewModel.DisplayedPhoto, rhs: SearchPhotos.RetrievePhotos.ViewModel.DisplayedPhoto) -> Bool {
                    return lhs.description == rhs.description
                }
            }
            var displayedPhotos: [DisplayedPhoto]

            static func == (lhs: SearchPhotos.RetrievePhotos.ViewModel, rhs: SearchPhotos.RetrievePhotos.ViewModel) -> Bool {
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
    case queryItems
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
    var user: User

    // Re map the keys
    enum CodingKeys: String, CodingKey {
        case resultDescription = "description"
        case urls
        case id
        case user
    }

    // DefaultValue
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        resultDescription = try container.decodeIfPresent(String.self, forKey: .resultDescription) ?? Constant.DecodingDefaultValue.description
        urls = try container.decodeIfPresent(PictureUrls.self, forKey: .urls) ?? Constant.DecodingDefaultValue.pictureUrls
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? Constant.DecodingDefaultValue.photoID
        user = try container.decodeIfPresent(User.self, forKey: .user) ?? Constant.DecodingDefaultValue.user
    }
}

struct PictureUrls: Codable {
    var small: String
}
struct User: Codable {
    var name: String
}
