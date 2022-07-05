//
// SearchPhotosRouter.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation
import UIKit

class SearchPhotosRouterImpl {
    private var identifierSearchPhotosViewImpl = "SearchPhotosViewImpl"

    var identifierSearchPhotosImpl: String {
        get { return identifierSearchPhotosViewImpl }
        set { identifierSearchPhotosViewImpl = newValue }
    }

    func build() -> SearchPhotosViewImpl {

        let viewController = SearchPhotosViewImpl()
        let presenter = SearchPhotosPresenterImpl()
        let interactor = SearchPhotosInteractorImpl(presenter: presenter)

        viewController.interactor = interactor
        viewController.interactor?.presenter = presenter
        viewController.interactor?.presenter.view = viewController

        return viewController
    }

    func instantiateViewInStoryboard() throws -> SearchPhotosViewImpl {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // --- Check ID.
        if !storyboard.isIDViewControllerExist(id: identifierSearchPhotosViewImpl) {
            throw ErrorStoryboard.storyboardID
        }
        let view = storyboard.instantiateViewController(withIdentifier: identifierSearchPhotosViewImpl)

        // --- Casting.
        guard let searchPhotosViewImpl = view as? SearchPhotosViewImpl else {
            throw ErrorStoryboard.casting
        }

		return searchPhotosViewImpl
    }
}

// MARK: - STORYBOARD
extension UIStoryboard {
    func isIDViewControllerExist(id: String) -> Bool {
        if let idenfiersList = self.value(forKey: "identifierToNibNameMap") as? [String: Any] {
            if idenfiersList[id] != nil {
                return true
            }
        }
        return false
    }
}

// MARK: - ERROR
enum ErrorStoryboard: Error {
    case storyboardID
    case casting
}
