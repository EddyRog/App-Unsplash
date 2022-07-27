//
// ShowPhotoViewImpl.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation
import UIKit

protocol ShowPhotoDisplayLogic {
    func displayPhoto(with: ShowPhoto.FetchBook.ViewModel)
}

class ShowPhotoViewController: UIViewController {

	static let identifier = "ShowPhotoViewController"
    internal var photoDescription = ""
    var router: ShowPhotoRoutingLogic?
    var interactor: (ShowPhotoBusinessLogic & ShowPhotoDataStore)?

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.fetchPhotoWithID()
    }
}

extension ShowPhotoViewController: ShowPhotoDisplayLogic {
    func displayPhoto(with photoViewModel: ShowPhoto.FetchBook.ViewModel) {
        photoDescription = photoViewModel.displayedPhotos.description
    }
}
