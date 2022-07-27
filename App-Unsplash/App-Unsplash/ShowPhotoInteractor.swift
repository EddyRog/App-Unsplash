//
// ShowPhotoInteractorImpl.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

protocol ShowPhotoDataStore {
    var dataPhotoID: String? { get set }
}

protocol ShowPhotoBusinessLogic {
    func fetchPhotoWithID()
}

class ShowPhotoInteractor: ShowPhotoBusinessLogic, ShowPhotoDataStore {
    var dataPhotoID: String?
    var worker: PhotosWorker?
    weak var presenter: ShowPhotoPresentationLogic?

    func fetchPhotoWithID() {
        // get photo ID
        // pass the id to worker
		let internalID = "IDxxxx"
        var response = ShowPhoto.FetchBook.Response(photo: Photo(description: "Ford in to the"))

        worker?.fetchPhoto(withID: internalID, completionHandler: { photo in
            // map to response
            // send back interactor -> presenter
            response.photo = photo
            self.presenter?.presentPhoto(response: response)
        })
    }
}
