//
// SearchPhotosWorker.swift
// App-Unsplash
// Created in 2022
// Swift 5.0

import Foundation

protocol PhotosServiceProtocol {
    func fetchPhotos(withRequest: String, completionHandler: @escaping ([Photo]) -> Void)
    func fetchPhoto(withID: String, completionHandler: @escaping (Photo) -> Void)
}

class PhotosWorker {
    var service: PhotosServiceProtocol?

    internal init(service myService: SearchPhotoService) {
        switch myService {
        	case .api:
            	self.service = PhotosServiceAPI()
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
    func fetchPhoto(withID id: String, completionHandler fetchCompletion: @escaping (Photo) -> Void) {
        // call with a specific service
        service?.fetchPhoto(withID: id, completionHandler: { photo in
			// map
            fetchCompletion(photo)
        })
    }
}

enum SearchPhotoService {
    case api
    case noService
}
