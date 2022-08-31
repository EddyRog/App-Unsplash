//
// ShowPhotoViewImpl.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation
import UIKit


protocol ShowPhotoViewable: AnyObject {
    func displayRetrievedPhoto(with viewModel: ShowPhoto.RetrievePhoto.ViewModel)
}

class ShowPhotoViewController: UIViewController {

    private (set) var interactor: ShowPhotosInteractable?
    private (set) var router: ShowPhotoRouter?

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let idPhoto = router?.idPhoto {
            showPhoto(withID: ShowPhoto.RetrievePhoto.Request.init(query: idPhoto))
        }
    }
    func showPhoto(withID request: ShowPhoto.RetrievePhoto.Request) {
        interactor?.retrievePhoto(withID: request)
    }

    func setRouter(_ showPhotoRouter: ShowPhotoRouter) {
        router = showPhotoRouter
    }
    func setInteractor(_ showPhotoInteractor: ShowPhotosInteractable) {
		interactor = showPhotoInteractor
    }
}

extension ShowPhotoViewController: ShowPhotoViewable {
    func displayRetrievedPhoto(with viewModel: ShowPhoto.RetrievePhoto.ViewModel) {
        DispatchQueue.main.async {

            // configure uiImage
            var smallurlUIImage = UIImage(named: "Image")

            if let dataImage = viewModel.displayedPhoto.urlsmallImage {
                if dataImage != "" {
                    let dataURL = Helper.makePicture(with: dataImage)
                    smallurlUIImage = UIImage(data: dataURL)
                }
            }

            // sets
            self.imageImageView.image = smallurlUIImage
            self.descriptionLabel.text = viewModel.displayedPhoto.description
            self.userNameLabel.text = viewModel.displayedPhoto.username
        }
    }
}
