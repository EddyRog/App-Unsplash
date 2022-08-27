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

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let idPhoto = router?.idPhoto {
            showPhoto(withID: ShowPhoto.FetchPhoto.Request.init(query: idPhoto))
        }
    }

    func showPhoto(withID request: ShowPhoto.FetchPhoto.Request) {
        interactor?.retrievePhoto(withID: request)
    }
}

extension ShowPhotoViewController: ShowPhotoDisplayLogic {
    func displayRetrievedPhoto(with viewModel: ShowPhoto.FetchPhoto.ViewModel) {
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
