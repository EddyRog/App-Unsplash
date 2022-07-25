//
// InteractorSearchPhotos.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

protocol SearchPhotosBusinessLogic {
    func fetchPhotos(withRequest: SearchPhotos.FetchPhotos.Request)
//    func searchPhotosIndexPath(_ indexpath: IndexPath)
}
protocol SearchPhotosDataStoreProtocol {
    var dataStorePhotos: [Response] {get set}
}

class SearchPhotosInteractor: SearchPhotosBusinessLogic, SearchPhotosDataStoreProtocol {
    var worker: SearchPhotosWorker?
    var presenter: SearchPhotosPresentationLogic?
    var dataStorePhotos: [Response] = []

    func fetchPhotos(withRequest request: SearchPhotos.FetchPhotos.Request) {

        worker?.fetchPhotos(withRequest: "", completionHandler: { [weak self] photos in
            guard let this = self else {return}

            // --- handle the response.
            var response = SearchPhotos.FetchPhotos.Response.init(photos: .init())
            response.photos = photos

            this.presenter?.presentFetchedPhotos(with: response)
        })
    }
//    func searchPhotos(with request: String) {
//        worker?.searchPhotos(with: request, completion: {[weak self] rep in
//            guard let this = self else {return}
//            // get the response from worker
//
//            // save the rep in data store
//            this.dataStorePhotos = rep
//
//            // send back the response the presenter
//            this.presenter?.presentSearchPhotos(with: rep)
//            this.presenter?.presentSearchPhotos(with: <#T##[Response]#>)
//        })
//	}

    func searchPhotosIndexPath(_ indexpath: IndexPath) {
        var photoID = ""
        if !dataStorePhotos.isEmpty {
            if let id = dataStorePhotos[indexpath.row].id {
                photoID = id
            }
        }
//        presenter?.interactor(didFindIdPhoto: photoID)
    }
}
