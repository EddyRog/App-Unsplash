//
// SearchPhotosRouter.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation
import UIKit

class SearchPhotosRouterImpl {
    // represent the current navigation Controller
    weak var source: UIViewController?

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

        searchPhotosViewImpl.interactor = interactor
        searchPhotosViewImpl.router = self
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.view = searchPhotosViewImpl

        self.source = searchPhotosViewImpl

		return searchPhotosViewImpl
    }

    /*
     // used to init programmatically
     func build() -> SearchPhotosViewImpl {

     let searchPhotosViewImpl = SearchPhotosViewImpl()
     let searchPhotosInteractorImpl = SearchPhotosInteractorImpl()
     let searchPhotosPresenterImpl = SearchPhotosPresenterImpl()


     searchPhotosViewImpl.interactor = searchPhotosInteractorImpl
     searchPhotosInteractorImpl.presenter = searchPhotosPresenterImpl

     return searchPhotosViewImpl
     }*/
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

class SceneFactory {
    func makeSearchPhotosDetailsScene() -> UIViewController {
        let detailController = UIViewController()
        detailController.view.backgroundColor = .red
        return detailController
    }
}
