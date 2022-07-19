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
    var photos: Photos
}

struct Photos: Codable {
    var results: [Result]
}

// swiftlint:disable identifier_name
struct Result: Codable {
    var resultDescription: String

    // Re map the keys
    enum CodingKeys: String, CodingKey {
        case resultDescription = "description"
    }

    // DefaultValue
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        resultDescription = try container.decodeIfPresent(String.self, forKey: .resultDescription) ?? "😖 NO DESCRIPTION"
    }
}

