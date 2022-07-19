//
// InteractorSearchPhotos.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

protocol SearchPhotosInteractor {
    func searchPhotos(with request: String)
}

protocol DataStore {
    var dataID: String? { get }
}

class SearchPhotosInteractorImpl: SearchPhotosInteractor, DataStore {
    var dataID: String?
    var worker: SearchPhotosWorker?
    var presenter: SearchPhotosPresenter?

    func searchPhotos(with request: String) {
        print("dee  L\(#line)      [🔲\(type(of: self))  🔲\(#function) ] ")
        worker?.searchPhotos(with: request, completion: {[weak self] rep in
            guard let this = self else {return}
            // get the response from worker
            // send back the response the presenter
            this.presenter?.presentSearchPhotos(with: rep)
        })
    }
}
