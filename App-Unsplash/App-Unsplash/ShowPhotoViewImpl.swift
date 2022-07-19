//
// ShowPhotoViewImpl.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation
import UIKit

protocol ShowPhotoView: AnyObject {
    func displayPhoto(with: ShowPhoto.GetPhoto.ViewModel)
}

class ShowPhotoViewImpl: UIViewController, ShowPhotoView {

    var interactor: ShowPhotoInteractor?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.getPhoto(width: "")
    }

    func displayPhoto(with: ShowPhoto.GetPhoto.ViewModel) {
        // 
    }
}
