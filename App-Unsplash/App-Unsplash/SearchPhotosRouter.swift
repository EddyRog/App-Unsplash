//
// SearchPhotosRouter.swift
// App-Unsplash
// Created in 2022
// Swift 5.0

import UIKit

protocol SearchPhotosRoutable {
    var navigationController: UINavigationController { get set }

    func rootToShowPhoto(withID: String)
}

class SearchPhotosRouter: SearchPhotosRoutable {

    internal var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func rootToShowPhoto(withID idPhoto: String) {
        guard let showPhotoViewController = try? ShowPhotoConfigurator(navController: navigationController, idPhoto: idPhoto).createModule() else { return }
        navigationController.pushViewController(showPhotoViewController, animated: true)
    }
}
