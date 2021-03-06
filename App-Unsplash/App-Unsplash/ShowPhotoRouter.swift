//
// ShowPhotoRouter.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation
import UIKit

protocol ShowDataPassing {
    var dataPhotoID: ShowPhotoDataStore? { get } // access to dataStore
}
protocol ShowPhotoRoutingLogic {
    var navigationController: UINavigationController? { get } // used to push
}

class ShowPhotoRouter: ShowPhotoRoutingLogic, ShowDataPassing {
    var dataPhotoID: ShowPhotoDataStore?
    var navigationController: UINavigationController?
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
