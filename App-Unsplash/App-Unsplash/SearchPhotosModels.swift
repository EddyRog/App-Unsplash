//
// Models.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

// ==================
// MARK: - Transfer object
// ==================
struct Response: Equatable {
    var description: String
}
struct ViewModel: Equatable {
    var description: String
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
    let photos: Photos
}

struct Photos: Codable {
    let results: [Result]
}

struct Result: Codable {
    //    var id: String
    //    var urls: Urls
    var description: String
}

struct Urls: Codable {
    var small: String
}
