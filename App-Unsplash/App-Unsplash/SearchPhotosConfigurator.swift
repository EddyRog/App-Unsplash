//
// SearchPhotosConfiguratorImpl.swift
// App-Unsplash
// Created in 2022
// Swift 5.0
// ✔︎

import Foundation
import UIKit

class SearchPhotosConfigurator {
    var identifier = "SearchPhotosViewController"

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

        // --- configure the connection of layers.
        let searchPhotosInteractor = SearchPhotosInteractor()
        let searchPhotosRouter = SearchPhotosRouter()
        let searchPhotosPresenter = SearchPhotosPresenter()

		// --- ViewController -> interactor & router.
        searchPhotosViewController.interactor = searchPhotosInteractor
        searchPhotosViewController.router = searchPhotosRouter

        // --- Interactor -> presenter.
        searchPhotosInteractor.presenter = searchPhotosPresenter

        // --- Presenter -> viewcontroller.
        searchPhotosPresenter.viewController = searchPhotosViewController

        return searchPhotosViewController
    }
}
