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

    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.description == rhs.description
    }
}
