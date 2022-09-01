//
// Constants.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

enum URLQuery: RawRepresentable {
    typealias RawValue = (key: String, value: String)
    case cliendID
    case page
    init?(rawValue: (key: String, value: String)) { return nil }

    var rawValue: (key: String, value: String) {
        switch self {
            case .cliendID:
                return ("client_id", "a76ebbad189e7f2ae725980590e4c520a525e1db029aa4cea87b44383c8a1ec4")
            case .page:
                return ("page", "0")
        }
    }
}
enum Constant {
    enum SearchPhoto {
        static var identifierViewController = "SearchPhotosViewController"
        static let placeHolderText = "Search Photos likes car or cat"
        static let idCell = "SearchPhotosCell"
        static let defaultImageName = "Image"
    }
    enum ShowPhoto {
        static var identifierViewController = "ShowPhotoViewController"
    }
    enum DecodingDefaultValue {
        static let photoID = "😖 NO ID"
        static let description = "❌ NO DESCRIPTION"
        static let pictureUrls = PictureUrls(small: "")
        static let user = User(name: "No name")
    }
    enum URL {
        static var scheme = "https"
        static var host = "api.unsplash.com"
        static var urlQuery = URLQuery.self
    }
}
