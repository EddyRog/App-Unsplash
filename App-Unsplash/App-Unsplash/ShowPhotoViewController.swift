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
    var router: ShowPhotoRoutingLogic?
    var interactor: (ShowPhotoBusinessLogic & ShowDataStore)?
}

extension ShowPhotoViewController: ShowPhotoDisplayLogic {
    func displayPhoto(with: ShowPhoto.FetchBook.ViewModel) {
        // TODO: ❎ impl ❎
    }
}



//
//protocol ShowPhotoView: AnyObject {
//    func displayPhoto(with: ShowPhoto.GetPhoto.ViewModel)
//}
//
//class ShowPhotoViewImpl: UIViewController, ShowPhotoView {
//    var interactor: ShowPhotoInteractor?
//    var router: ShowPhotoRouter?
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        interactor?.getPhoto(width: "")
//    }
//
//    func displayPhoto(with: ShowPhoto.GetPhoto.ViewModel) {
//        //
//    }
//}
//
