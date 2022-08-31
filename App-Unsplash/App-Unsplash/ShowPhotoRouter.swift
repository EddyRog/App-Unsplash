//
// ShowPhotoRouter.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import UIKit

protocol ShowPhotoRoutable {
    var navigationController: UINavigationController { get set }
}

class ShowPhotoRouter: ShowPhotoRoutable {
    var navigationController: UINavigationController
    var idPhoto: String

    internal init(navigationController: UINavigationController, idPhoto: String) {
        self.navigationController = navigationController
        self.idPhoto = idPhoto
    }
}
