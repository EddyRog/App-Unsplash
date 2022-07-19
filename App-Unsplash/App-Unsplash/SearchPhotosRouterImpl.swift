//
// SearchPhotosRouter.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation
import UIKit

protocol SearchPhotosRouter {
    func showSearchPhotoDetails()
}

class SearchPhotosRouterImpl: SearchPhotosRouter {
    // represent the current navigation Controller
    weak var source: UIViewController?



}

extension SearchPhotosRouterImpl {
    func showSearchPhotoDetails() {
        // build details ViewController
        let detailController = UIViewController()
        detailController.view.backgroundColor = .red

        // push it
        source?.navigationController?.pushViewController(detailController, animated: true)
    }
}

class SearchPhotosConfiguratorImpl {
    // used for storyboard
    func buildWithStoryboard(withIdentifier identifier: String = SearchPhotosViewImpl.identifier) throws -> SearchPhotosViewImpl {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // --- check ID.
        if !storyboard.isIDViewControllerExist(withIdentifier: identifier) {
            throw ErrorStoryboard.identifierNil
        }

        // --- Init from ID.
        let view = storyboard.instantiateViewController(withIdentifier: identifier)

        guard let searchPhotosViewImpl = view as? SearchPhotosViewImpl else {
            throw ErrorStoryboard.castingToSearchPhotosViewImpl
        }

        // --- set connection between layers
        let interactor = SearchPhotosInteractorImpl()
        let presenter = SearchPhotosPresenterImpl()
        let worker = SearchPhotosWorkerImpl()
        let router = SearchPhotosRouterImpl()

        searchPhotosViewImpl.interactor = interactor

        searchPhotosViewImpl.router = router
        router.source = searchPhotosViewImpl

        interactor.presenter = presenter

        interactor.worker = worker

        presenter.view = searchPhotosViewImpl


        return searchPhotosViewImpl
    }
}
