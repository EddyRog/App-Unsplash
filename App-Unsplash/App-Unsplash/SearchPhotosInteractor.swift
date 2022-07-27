//
// InteractorSearchPhotos.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

protocol SearchPhotosBusinessLogic {
    func fetchPhotos(withRequest: SearchPhotos.FetchPhotos.Request)
}
protocol SearchPhotosDataStoreProtocol {
    var dataStorePhotos: [Photo] {get}
}

class SearchPhotosInteractor: SearchPhotosBusinessLogic, SearchPhotosDataStoreProtocol {
    var worker: PhotosWorker?
    var presenter: SearchPhotosPresentationLogic?
    var dataStorePhotos: [Photo] = []

    func fetchPhotos(withRequest request: SearchPhotos.FetchPhotos.Request) {

        worker?.fetchPhotos(withRequest: request.query, completionHandler: { [weak self] photos in
            guard let this = self else { return }

            // --- handle the response.
            var response = SearchPhotos.FetchPhotos.Response.init(photos: .init())
            response.photos = photos

            // set data store
            this.dataStorePhotos = photos

            this.presenter?.presentFetchedPhotos(with: response)
        })
    }

    func searchPhotosIndexPath(_ indexpath: IndexPath) {
//        var photoID = ""
//        if !dataStorePhotos.isEmpty {
//            if let id = dataStorePhotos[indexpath.row].id {
//                photoID = id
//            }
//        }
//        presenter?.interactor(didFindIdPhoto: photoID)
    }
}
