//
// ShowPhotoRouter.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import UIKit

protocol ShowPhotoRoutingLogic {
    var navigationController: UINavigationController { get set }
}

class ShowPhotoRouter: ShowPhotoRoutingLogic {
    var navigationController: UINavigationController
    var idPhoto: String

    internal init(navigationController: UINavigationController, idPhoto: String) {
        self.navigationController = navigationController
        self.idPhoto = idPhoto
    }
}
