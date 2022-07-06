//
// FetcherSearchPhotos.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation
protocol SearchPhotosFetcher {
    func fetch(with request: String, completion: ([Photo]) -> Void)
}

class FetcherSearchPhotosImpl {
    var parser: SearchPhotosParser?

    func fetch(with request: String, completion: ([Photo]) -> Void) {
        // call the parser with the good request

        let photos = [Photo]()
        completion(photos)
    }
}
