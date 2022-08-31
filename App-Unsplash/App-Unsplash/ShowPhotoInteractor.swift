//
// ShowPhotoInteractor.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

protocol ShowPhotosBusinessLogic {
//    func retrivePhotos(withRequest: ShowPhoto.FetchPhoto.Request)
    func retrievePhoto(withID: ShowPhoto.RetrievePhoto.Request)
}
class ShowPhotoInteractor: ShowPhotosBusinessLogic {

    var worker: PhotosWorkerLogic?
    var presenter: ShowPhotoPresentationLogic?

    func retrievePhoto(withID photoID: ShowPhoto.RetrievePhoto.Request) {

        // worker
        worker?.retrievePhoto(withID: photoID.query, completionRetrieve: { [weak self] photo in
            guard let this = self else {return}

            // get the response
            if let photo = photo {
                let response = ShowPhoto.RetrievePhoto.Response(photo: photo)
                // send back to
                this.presenter?.presentRetrievePhoto(with: response)
            } else {
                this.presenter?.presentRetrievePhoto(with: ShowPhoto.RetrievePhoto.Response.init(photo: nil))
            }
        })
    }
}
