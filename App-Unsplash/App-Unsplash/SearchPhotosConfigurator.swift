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

    internal init(navController: UINavigationController) {
        self.navController = navController
    }

    func createModule() throws -> SearchPhotosViewController {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // --- check if the id exist.
        if !storyboard.isIDViewControllerExist(withIdentifier: Constant.SearchPhoto.identifierViewController) {
            throw ErrorStoryboard.identifierNil
        }

        let viewcontroller = storyboard.instantiateViewController(withIdentifier: Constant.SearchPhoto.identifierViewController) // --- init viewController from storyboard.

        guard let searchPhotosViewController = viewcontroller as? SearchPhotosViewController else {
            throw ErrorStoryboard.castingToSearchPhotosViewImpl
        }

        // ==================
        // MARK: - Connection Layer VIP
        // ==================
        // --- configure the connection of layers.
        let photosWorker = PhotosWorker()
        let searchPhotosPresenter = SearchPhotosPresenter(viewController: searchPhotosViewController)

        // --- Interactor -> presenter & worker.
        let searchPhotosInteractor = SearchPhotosInteractor(worker: photosWorker, presenter: searchPhotosPresenter)

        // --- Router -> navigationContorller.
        let searchPhotosRouter = SearchPhotosRouter(navigationController: navController)

		// --- ViewController -> interactor & router.
        searchPhotosViewController.setInteractor(searchPhotosInteractor)
        searchPhotosViewController.setRouter(searchPhotosRouter)

        // --- Presenter -> viewcontroller.
//        searchPhotosPresenter.viewController = searchPhotosViewController

        return searchPhotosViewController
    }
}
