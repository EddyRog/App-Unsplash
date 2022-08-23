//
// ShowPhotoViewImpl.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation
import UIKit


protocol ShowPhotoDisplayLogic: AnyObject {
    func displayRetrievedPhoto(with viewModel: ShowPhoto.FetchPhoto.ViewModel)
}

class ShowPhotoViewController: UIViewController {

    var interactor: ShowPhotosBusinessLogic?
    var router: ShowPhotoRouter?

    func showPhoto(withID request: ShowPhoto.FetchPhoto.Request) {
        interactor?.retrievePhoto(withID: request)
    }
}

extension ShowPhotoViewController: ShowPhotoDisplayLogic {
    func displayRetrievedPhoto(with viewModel: ShowPhoto.FetchPhoto.ViewModel) {
        // TODO: ❎ impl ❎
    }
}
