//
// ShowPhotoConfigurator.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0


import Foundation
import UIKit

class ShowPhotoConfigurator {
    func buildWithStoryboard(withIdentifier identifier: String = ShowPhotoViewController.identifier) throws -> ShowPhotoViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        // --- check ID.
        if !storyboard.isIDViewControllerExist(withIdentifier: identifier) {
            throw ErrorStoryboard.identifierNil
        }

        // Init from ID
        let viewController: UIViewController = storyboard.instantiateViewController(withIdentifier: identifier)

        guard let showPhotoViewController = viewController as? ShowPhotoViewController else {
            throw ErrorStoryboard.castingToSearchPhotosViewImpl
        }

        return showPhotoViewController
    }

    func configureModule(photoID: String, _ showPhotoViewController: ShowPhotoViewController) {
        let showPhotoRouter = ShowPhotoRouter(navigationController: UINavigationController(rootViewController: showPhotoViewController))
        let showPhotoInteractor = ShowPhotoInteractor()

        // viewController -> router
        showPhotoViewController.router                  = showPhotoRouter
        showPhotoViewController.interactor              = showPhotoInteractor
        showPhotoViewController.interactor?.dataPhotoID = photoID
    }
}
/*
 // FIXME: ⚠️ need to be deleted ⚠️
 //class ShowPhotoConfiguratorImpl {
 //    func buildWithStoryboard(withIdentifier identifier: String = "ShowPhotoViewImpl") throws -> ShowPhotoViewImpl {
 //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
 //        // --- check ID.
 //        if !storyboard.isIDViewControllerExist(withIdentifier: identifier) {
 //            throw ErrorStoryboard.identifierNil
 //        }
 //
 //        // --- Init from ID.
 //        let view = storyboard.instantiateViewController(withIdentifier: identifier)
 //
 //        guard let showPhotoViewImpl = view as? ShowPhotoViewImpl else {
 //            throw ErrorStoryboard.castingToSearchPhotosViewImpl
 //        }
 //
 //        return showPhotoViewImpl
 //    }
 //    func configureModule(photoID: String, viewController: ShowPhotoViewImpl) {
 //          _ = UINavigationController(rootViewController: viewController)
 //
 //        let router = ShowPhotoRouterImpl()
 //        let interactor = ShowPhotoInteractorImpl()
 //        interactor.photoID = photoID
 //        let presenter = ShowPhotoPresenterImpl()
 //        router.navigationController = viewController.navigationController
 //
 //        presenter.view = viewController
 //
 //        interactor.photoID = photoID
 //        interactor.presenter = presenter
 //
 //        viewController.router  = router
 //        viewController.interactor = interactor
 //
 //    }
 //}

 */
