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
    func fetch(with request: String, completion: ([Photo]) -> Void) {
        let photos = [Photo]()
        completion(photos)
    }
}
