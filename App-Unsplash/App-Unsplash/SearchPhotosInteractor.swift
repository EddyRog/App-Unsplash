//
// InteractorSearchPhotos.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

protocol SearchPhotosInteractable {
    func retrivePhotos(withRequest: SearchPhotos.RetrievePhotos.Request)
    func retrievePhotosOnNextPage(withRequest: SearchPhotos.RetrievePhotos.Request)
}

class SearchPhotosInteractor: SearchPhotosInteractable {
    private (set) var worker: PhotosWorkable?
    private (set) var presenter: SearchPhotosPresentable?

    init(worker: PhotosWorkable, presenter: SearchPhotosPresentable) {
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

    func retrievePhotosOnNextPage(withRequest request: SearchPhotos.RetrievePhotos.Request) {
        worker?.retrievePhotosOnNextPage(withRequest: request, completionRetrieve: { photos in
            // map response
            let responseFromNextPage: SearchPhotos.RetrievePhotos.Response = SearchPhotos.RetrievePhotos.Response(photos: photos)
            // send back

            self.presenter?.presentRetrievedPhotosOnNextPage(with: responseFromNextPage)
        })
    }
}
