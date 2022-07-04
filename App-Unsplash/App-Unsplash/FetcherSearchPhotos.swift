//
// FetcherSearchPhotos.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation
protocol FetcherSearchPhotos {
    func fetch(with request: String, completion: ([Photo]) -> Void)
}

class FetcherSearchPhotosImpl {
    var parser: ParserSearchPhotos?

    func fetch(with request: String, completion: ([Photo]) -> Void) {
        // call the parser with the good request

        let photos = [Photo]()
        completion(photos)
    }
}
