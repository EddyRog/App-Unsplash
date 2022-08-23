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
        let description = response.photo?.description ?? "No description"
        let urlsmallImage = response.photo?.urlsmallImage ?? "Image"

        // format response
        let descriptionUppercased = description.uppercased()

        let viewModel: ShowPhoto.FetchPhoto.ViewModel = .init(displayedPhoto: .init(
            urlsmallImage: urlsmallImage,
            description: descriptionUppercased)
        )

        viewController?.displayRetrievedPhoto(with: viewModel)
    }
}
