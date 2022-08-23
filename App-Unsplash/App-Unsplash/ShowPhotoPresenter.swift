//
// ShowPhotoPresenter.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

protocol ShowPhotoPresentationLogic {
    func presentRetrievePhoto(with response: ShowPhoto.FetchPhoto.Response)
}

class ShowPhotoPresenter: ShowPhotoPresentationLogic {

    weak var viewController: ShowPhotoDisplayLogic?

    func presentRetrievePhoto(with response: ShowPhoto.FetchPhoto.Response) {
        let viewModel = ShowPhoto.FetchPhoto.ViewModel(displayedPhoto: .init(description: ""))

        if let description = response.photo?.description {
            // format
            let upperDescription = description.uppercased()
            // map response to viewModel
            let viewModel = ShowPhoto.FetchPhoto.ViewModel(displayedPhoto: .init(description: upperDescription))
            viewController?.displayRetrievedPhoto(with: viewModel)
        } else {
            viewController?.displayRetrievedPhoto(with: viewModel)
        }
    }
}
