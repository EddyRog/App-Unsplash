//
// SearchPhotosWorker.swift
// App-Unsplash
// Created in 2022
// Swift 5.0

import Foundation

protocol SearchPhotosStoreProtocol {
    func fetchPhotos(withRequest: String, completionHandler: @escaping ([Photo]) -> Void)
}

class SearchPhotosWorker {

    var service: SearchPhotosStoreProtocol?

    func fetchPhotos(withRequest request: String, completionHandler: @escaping ([Photo]) -> Void) {
		// call with a specific service
        service?.fetchPhotos(withRequest: request, completionHandler: { responseFetched in
            DispatchQueue.main.async {
                // Handle the response if needed
                // Send back the response
				completionHandler(responseFetched)
            }
        })
    }

//    func searchPhotos(with request: String, completion: @escaping ([Response]) -> Void) {

//        serviceAPI?.searchPhotos(with: request) { responseDecoded in
//
//            completion(responseDecoded)
//        }
//    }
}

