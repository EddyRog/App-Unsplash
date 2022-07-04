//
// SearchPhotosRouter.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

class SearchPhotosRouterImpl {
    func build() -> SearchPhotosViewImpl {

        let viewController = SearchPhotosViewImpl()
        let presenter = SearchPhotosPresenterImpl()
        let interactor = SearchPhotosInteractorImpl(presenter: presenter)

        viewController.interactor = interactor
        viewController.interactor?.presenter = presenter
        viewController.interactor?.presenter.view = viewController

        return viewController
    }
}
