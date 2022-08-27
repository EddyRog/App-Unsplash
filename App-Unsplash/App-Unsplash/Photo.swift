//
// Photo.swift
// App-Unsplash
// Created in 2022
// Swift 5.0

import Foundation

struct Photo: Equatable {
    var urlsmallImage: String?
    var photoID: String
    var description: String?
    var userName: String

    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.urlsmallImage == rhs.urlsmallImage &&
        lhs.photoID == rhs.photoID &&
        lhs.description == rhs.description &&
        lhs.userName == rhs.userName
    }
}
