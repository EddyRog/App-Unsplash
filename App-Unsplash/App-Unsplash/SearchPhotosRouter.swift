////
//// SearchPhotosRouter.swift
//// App-Unsplash
//// Created in 2022
//// Swift 5.0
//
//

import UIKit

protocol SearchPhotosRoutingLogic {
    var navigationController: UINavigationController { get set }

    func rootToShowPhoto(withID: String)
}

class SearchPhotosRouter: SearchPhotosRoutingLogic {

    internal var navigationController: UINavigationController

    internal init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func rootToShowPhoto(withID idPhoto: String) {
        // create module
        guard let showPhotoViewController = try? ShowPhotoConfigurator(navController: navigationController, withIDPhoto: idPhoto).createModule() else { return }

        // navigation push
        navigationController.pushViewController(showPhotoViewController, animated: true)
    }
}
