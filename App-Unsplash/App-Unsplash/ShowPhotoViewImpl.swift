//
// ShowPhotoViewImpl.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation
import UIKit

class ShowPhotoViewImpl: UIViewController {
    var interactor: ShowPhotoInteractor?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.getPhoto(width: "")
    }
}

protocol ShowPhotoInteractor {
    func getPhoto(width id: String)
}
