//
// Seed.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import Foundation

struct Seed {
    struct Json {
        static let idPhoto = "a4S6KUuLeoM"
    }
    struct Photos {
        static let paris = Photo(description: "Paris")
        static let nice = Photo(description: "Nice")
    }
}
