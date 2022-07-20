//
// ShowPhotoRouterImpl.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation
import UIKit

protocol ShowPhotoRouter {
    var navigationController: UINavigationController? { get } // used to push
}

class ShowPhotoRouterImpl: ShowPhotoRouter {
    var navigationController: UINavigationController?
}
