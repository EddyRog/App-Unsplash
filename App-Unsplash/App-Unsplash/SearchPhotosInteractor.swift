//
// InteractorSearchPhotos.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

protocol SearchPhotosBusinessLogic {
//    func fetchPhotos(withRequest: SearchPhotos.FetchPhotos.Request)
    func retrivePhotos(withRequest: SearchPhotos.FetchPhotos.Request)
}

class SearchPhotosInteractor: SearchPhotosBusinessLogic {

    var worker: PhotosWorkerLogic?
    var presenter: SearchPhotosPresentationLogic?

    func retrivePhotos(withRequest request: SearchPhotos.FetchPhotos.Request) {

        worker?.retrievePhotos(withRequest: request.query) { photos in
            // map...
            let reponse: SearchPhotos.FetchPhotos.Response = .init(photos: photos)
            // send back to presenter...
            self.presenter?.presentFetchedPhotos(with: reponse)
        }
    }
}
