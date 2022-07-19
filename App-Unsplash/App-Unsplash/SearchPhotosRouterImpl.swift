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

    var data: String?

    // represent the current navigation Controller
    weak var source: UIViewController?

    func showSearchPhotoDetails() {
        // build details ViewController
        let detailController = UIViewController()
        detailController.view.backgroundColor = .red

        // push it
        source?.navigationController?.pushViewController(detailController, animated: true)
    }
}
