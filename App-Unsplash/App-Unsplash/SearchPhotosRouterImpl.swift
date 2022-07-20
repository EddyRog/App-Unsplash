//
// SearchPhotosRouter.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation
import UIKit

protocol SearchPhotosRouter {
    var navigationController: UINavigationController? { get } // used to push
    func showSearchPhotoDetails(with id: String)
}

class SearchPhotosRouterImpl: SearchPhotosRouter {
    var navigationController: UINavigationController?
    var data: String?


    weak var source: UIViewController? // represent the current navigation Controller
    weak var destionation: UIViewController?

    func showSearchPhotoDetails(with id: String) {
        let configurator = ShowPhotoConfiguratorImpl()
        guard let viewController = try? configurator.buildWithStoryboard() else { return }
        configurator.configureModule(photoID: id, viewController: viewController)

        destionation = viewController
        // push it
        if let destionation = destionation {
            navigationController?.pushViewController(destionation, animated: true)
        }
    }
}
