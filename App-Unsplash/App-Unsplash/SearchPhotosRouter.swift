//
// SearchPhotosRouter.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation
import UIKit

protocol SearchPhotosRouterProtocol {
    var navigationController: UINavigationController? { get } // used to push
    func showSearchPhotoDetails(with id: String)
}

protocol SearchPhotosRoutingLogic {
    func rootToSearchPhotosDetails(withID: String)
}
class SearchPhotosRouter: SearchPhotosRoutingLogic {

    var navigationController: UINavigationController?

    func rootToSearchPhotosDetails(withID: String) {
        navigationController?.pushViewController(UIViewController(), animated: true)
    }

    //    var data: String?
//    weak var source: UIViewController? // represent the current navigation Controller
//    weak var destionation: UIViewController?
//
//    func showSearchPhotoDetails(with id: String) {
//        let configurator = ShowPhotoConfiguratorImpl()
//        guard let viewController = try? configurator.buildWithStoryboard() else { return }
//        configurator.configureModule(photoID: id, viewController: viewController)
//
//        destionation = viewController
//        // push it
//        if let destionation = destionation {
//            navigationController?.pushViewController(destionation, animated: true)
//        }
//    }
}


// ⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬⌬

