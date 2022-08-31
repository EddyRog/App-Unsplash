//
// InteractorSearchPhotos.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

protocol SearchPhotosInteractable {
    func retrivePhotos(withRequest: SearchPhotos.RetrievePhotos.Request)
}

class SearchPhotosInteractor: SearchPhotosInteractable {

    private (set) var worker: PhotosWorkerLogic?
    private (set) var presenter: SearchPhotosPresentable?

    init(worker: PhotosWorkerLogic, presenter: SearchPhotosPresentable) {
        self.worker = worker
        self.presenter = presenter
    }


    func retrivePhotos(withRequest request: SearchPhotos.RetrievePhotos.Request) {

        worker?.retrievePhotos(withRequest: request.query) { photos in
            // map...
            let reponse: SearchPhotos.RetrievePhotos.Response = .init(photos: photos)
            // send back to presenter...
            self.presenter?.presentFetchedPhotos(with: reponse)
        }
    }
}
