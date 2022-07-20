//
// InteractorSearchPhotos.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

protocol SearchPhotosInteractor {
    func searchPhotos(with request: String)
    func searchPhotosIndexPath(_ indexpath: IndexPath)
}

protocol DataStorePhotos {
    var dataStorePhotos: [Response] {get set}
}

class SearchPhotosInteractorImpl: SearchPhotosInteractor, DataStorePhotos {
    var dataStorePhotos: [Response] = []
    var worker: SearchPhotosWorker?
    var presenter: SearchPhotosPresenter?

    func searchPhotos(with request: String) {
        print("dee  L\(#line)      [🔲\(type(of: self))  🔲\(#function) ] ")
        worker?.searchPhotos(with: request, completion: {[weak self] rep in
            guard let this = self else {return}
            // get the response from worker

            // save the rep in data store
            this.dataStorePhotos = rep

            // send back the response the presenter
            this.presenter?.presentSearchPhotos(with: rep)
        })
	}

    func searchPhotosIndexPath(_ indexpath: IndexPath) {
//        let response = dataStorePhotos[indexpath.row]
        var photoID = ""
        if !dataStorePhotos.isEmpty {
            if let id = dataStorePhotos[indexpath.row].id {
                photoID = id
            }
        }
        presenter?.interactor(didFindIdPhoto: photoID)
    }
}
