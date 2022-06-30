//
// Models.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

struct Response: Equatable {
    var value: [Photo]

    static func == (lhs: Response, rhs: Response) -> Bool {
        return lhs.value == rhs.value
    }
}

struct ViewModel: Equatable {
    var description: String
    var thumbsUrlImage: String
}
