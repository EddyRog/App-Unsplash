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

        let interactor = ShowPhotoInteractor()
        let router = ShowPhotoRouter(navigationController: navController, idPhoto: idPhoto)
        let presenter = ShowPhotoPresenter(viewController: showPhotoViewController)

        // --- ViewController -> Interactor.
        showPhotoViewController.interactor = interactor
        router.idPhoto = idPhoto
        showPhotoViewController.router = router

        // --- Interactor -> Presenter.
        interactor.presenter = presenter
        interactor.worker = PhotosWorker()

        // --- Presenter -> ViewController.
//        presenter.viewController
        //presenter.viewController = showPhotoViewController

        // ==================
        // MARK: - Connection Layer VIP
        // ==================

        return showPhotoViewController
    }
}
