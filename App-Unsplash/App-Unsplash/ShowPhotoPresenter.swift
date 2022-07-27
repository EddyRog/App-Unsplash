//
// ShowPhotoPresenterImpl.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation
import UIKit

protocol ShowPhotoPresentationLogic: AnyObject {
    func presentPhoto(response: ShowPhoto.FetchBook.Response)
}
class ShowPhotoPresenter: ShowPhotoPresentationLogic {
    var viewController: ShowPhotoDisplayLogic?
    func presentPhoto(response: ShowPhoto.FetchBook.Response) {

        // reponse -> ViewModel
        let viewModel = ShowPhoto.FetchBook.ViewModel(
            displayedPhotos: .init(
                description: response.photo.description ?? ""
            )
        )
        // call viewController
        viewController?.displayPhoto(with: viewModel)
    }
}
