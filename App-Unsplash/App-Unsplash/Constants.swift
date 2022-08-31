//
// Constants.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

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
}
