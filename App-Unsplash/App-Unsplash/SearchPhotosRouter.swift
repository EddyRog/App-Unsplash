//
// SearchPhotosRouter.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation
import UIKit

protocol SearchPhotosRoutingLogic {
    var navigationController: UINavigationController? { get } // used to push
    func rootToSearchPhotosDetails(withID: String)
}

class SearchPhotosRouter: SearchPhotosRoutingLogic {

    weak var navigationController: UINavigationController?

    func rootToSearchPhotosDetails(withID: String) {
        // target to go to

        let showPhotoConfigurator = ShowPhotoConfigurator()
        if let showPhotoViewController = try? showPhotoConfigurator.buildWithStoryboard() {
            showPhotoConfigurator.configureModule(photoID: withID, showPhotoViewController)
            navigationController?.pushViewController(showPhotoViewController, animated: true)
        }
    }
}
