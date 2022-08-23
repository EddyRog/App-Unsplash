//
// ShowPhotoViewImpl.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation
import UIKit

class ShowPhotoViewController: UIViewController {

    var interactor: ShowPhotosBusinessLogic?
    var router: ShowPhotoRouter?

    func showPhoto(withID request: ShowPhoto.FetchPhoto.Request) {
//        interactor?.retrivePhotos(withRequest: request)
        interactor?.retrievePhoto(withID: request)
    }
}
