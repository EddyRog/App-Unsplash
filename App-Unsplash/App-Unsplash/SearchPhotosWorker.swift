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

    internal init(service myService: SearchPhotoService) {
        switch myService {
        	case .api:
            	self.service = SearchPhotosServiceAPI()
        	case .noService:
            	self.service = nil
        }
//        self.service = service
    }

    func fetchPhotos(withRequest request: String, completionHandler: @escaping ([Photo]) -> Void) {
		// call with a specific service
        service?.fetchPhotos(withRequest: request, completionHandler: { responseFetched in
            print(responseFetched)
            DispatchQueue.main.async {
                // Handle the response if needed
                // Send back the response
				completionHandler(responseFetched)
            }
        })
    }
}

enum SearchPhotoService {
    case api
    case noService
}
