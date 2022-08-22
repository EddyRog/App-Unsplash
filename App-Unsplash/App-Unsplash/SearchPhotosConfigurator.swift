//
// SearchPhotosConfiguratorImpl.swift
// App-Unsplash
// Created in 2022
// Swift 5.0
// ✔︎

import Foundation
import UIKit

class SearchPhotosConfigurator: Coordinator {
    var navController: UINavigationController
    var identifier = "SearchPhotosViewController"

    internal init(navController: UINavigationController, identifier: String = "SearchPhotosViewController") {
        self.navController = navController
        self.identifier = identifier
    }

    func start() {}

    func createModule() throws -> SearchPhotosViewController {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // --- check if the id exist.
        if !storyboard.isIDViewControllerExist(withIdentifier: identifier) {
            throw ErrorStoryboard.identifierNil
        }
        // --- init viewController from storyboard.
        let viewcontroller = storyboard.instantiateViewController(withIdentifier: identifier)

        guard let searchPhotosViewController = viewcontroller as? SearchPhotosViewController else {
            throw ErrorStoryboard.castingToSearchPhotosViewImpl
        }

        // ==================
        // MARK: - Connection Layer VIP
        // ==================
        // --- configure the connection of layers.
        let searchPhotosInteractor = SearchPhotosInteractor()
        let photosWorker = PhotosWorker()

        let searchPhotosPresenter = SearchPhotosPresenter()
        let searchPhotosRouter = SearchPhotosRouter(navigationController: navController)

		// --- ViewController -> interactor & router.
        searchPhotosViewController.interactor = searchPhotosInteractor
//        searchPhotosRouter.
        searchPhotosViewController.router = searchPhotosRouter

        // --- Interactor -> presenter & worker.
        searchPhotosInteractor.presenter = searchPhotosPresenter
        searchPhotosInteractor.worker = photosWorker

        // --- Presenter -> viewcontroller.
        searchPhotosPresenter.viewController = searchPhotosViewController

        return searchPhotosViewController
    }
}
