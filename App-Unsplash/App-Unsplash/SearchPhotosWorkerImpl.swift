//
// SearchPhotosWorker.swift
// App-Unsplash
// Created in 2022
// Swift 5.0

import Foundation

protocol SearchPhotosWorker {
    func searchPhotos(with request: String, completion: @escaping ([Response]) -> Void)
}

class SearchPhotosWorkerImpl: SearchPhotosWorker {
    var serviceAPI: SearchPhotosServiceAPI? = SearchPhotosServiceAPIImpl()

    func searchPhotos(with request: String, completion: @escaping ([Response]) -> Void) {

        serviceAPI?.searchPhotos(with: request) { responseDecoded in

            completion(responseDecoded)
        }
    }
}

