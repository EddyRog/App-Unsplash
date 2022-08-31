//
// ShowPhotoConfigurator.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

import Foundation
import UIKit

class ShowPhotoConfigurator: Coordinator {

    internal var navController: UINavigationController
    private var idPhoto: String

    init(navController: UINavigationController, idPhoto: String) {
        self.navController = navController
        self.idPhoto = idPhoto
    }

    func createModule() throws -> ShowPhotoViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        // --- check if the id exist.
        if !storyboard.isIDViewControllerExist(withIdentifier: Constant.ShowPhoto.identifierViewController) {
            throw ErrorStoryboard.identifierNil
        }

        // --- init viewController from storyboard.
        let viewcontroller = storyboard.instantiateViewController(withIdentifier: Constant.ShowPhoto.identifierViewController)

        guard let showPhotoViewController = viewcontroller as? ShowPhotoViewController else {
            throw ErrorStoryboard.castingToSearchPhotosViewImpl
        }
        let worker = PhotosWorker()
        let presenter = ShowPhotoPresenter(viewController: showPhotoViewController)
        let interactor = ShowPhotoInteractor(worker: worker, presenter: presenter)
        let router = ShowPhotoRouter(navigationController: navController, idPhoto: idPhoto)

        // --- ViewController -> Interactor & router.
        showPhotoViewController.setInteractor(interactor)

        router.idPhoto = idPhoto
        showPhotoViewController.setRouter(router)

        // ==================
        // MARK: - Connection Layer VIP
        // ==================
        return showPhotoViewController
    }
}
