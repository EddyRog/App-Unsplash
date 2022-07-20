//
// SearchPhotosConfiguratorImpl.swift
// App-Unsplash
// Created in 2022
// Swift 5.0

import Foundation
import UIKit

class SearchPhotosConfiguratorImpl {

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

        //        configureModule(searchPhotosViewImpl)

        return searchPhotosViewImpl
    }

    // used for storyboard
    func configureModule(_ searchPhotosViewImpl: SearchPhotosViewImpl) {
        // --- set connection between layers
        let interactor = SearchPhotosInteractorImpl()
        let presenter = SearchPhotosPresenterImpl()
        let worker = SearchPhotosWorkerImpl()
        let router = SearchPhotosRouterImpl()

        // router -> ( source, navigationController )
        router.source = searchPhotosViewImpl
        router.navigationController = searchPhotosViewImpl.navigationController

        

        // interactor -> ( presenter, worker)
        interactor.presenter = presenter
        interactor.worker = worker

        // view -> ( interactor, router )
        searchPhotosViewImpl.interactor = interactor
        searchPhotosViewImpl.router = router

        // presenter -> ( View )
        presenter.view = searchPhotosViewImpl
    }
}
