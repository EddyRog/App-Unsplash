//
// ShowPhotoConfigurator.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0


import Foundation
import UIKit

class ShowPhotoConfigurator: Coordinator {

    var navController: UINavigationController
    var idPhoto: String
    var identifier = "ShowPhotoViewController"

    internal init(navController: UINavigationController, withIDPhoto idPhoto: String, identifier: String = "ShowPhotoViewController") {
        self.navController = navController
        self.idPhoto = idPhoto
        self.identifier = identifier
    }

    func createModule() throws -> ShowPhotoViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // --- check if the id exist.
        if !storyboard.isIDViewControllerExist(withIdentifier: identifier) {
            throw ErrorStoryboard.identifierNil
        }

        // --- init viewController from storyboard.
        let viewcontroller = storyboard.instantiateViewController(withIdentifier: identifier)

        guard let showPhotoViewController = viewcontroller as? ShowPhotoViewController else {
            throw ErrorStoryboard.castingToSearchPhotosViewImpl
        }

        let interactor = ShowPhotoInteractor()
        let router = ShowPhotoRouter(navigationController: navController, idPhoto: idPhoto)
        let presenter = ShowPhotoPresenter()

        // --- ViewController -> Interactor.
        showPhotoViewController.interactor = interactor
        router.idPhoto = idPhoto
        showPhotoViewController.router = router

        // --- Interactor -> Presenter.
        interactor.presenter = presenter
        interactor.worker = PhotosWorker()

        // --- Presenter -> ViewController.
        presenter.viewController = showPhotoViewController

        // ==================
        // MARK: - Connection Layer VIP
        // ==================

        return showPhotoViewController
    }
}
