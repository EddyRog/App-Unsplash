//
// ShowPhotoPresenter.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

protocol ShowPhotoPresentatable {
    func presentRetrievePhoto(with response: ShowPhoto.RetrievePhoto.Response)
}

class ShowPhotoPresenter: ShowPhotoPresentatable {

    weak private (set) var viewController: ShowPhotoViewable?

    init(viewController: ShowPhotoViewable) {
        self.viewController = viewController
    }

    func presentRetrievePhoto(with response: ShowPhoto.RetrievePhoto.Response) {
        let photoid  = response.photo?.photoID
        let username = response.photo?.userName

        let description = response.photo?.description ?? "No description"
        let urlsmallImage = response.photo?.urlsmallImage ?? "Image"

        let viewModel: ShowPhoto.RetrievePhoto.ViewModel = .init(displayedPhoto: .init(
            urlsmallImage: urlsmallImage,
            photoID: photoid,
            description: description.uppercased(),
            username: username))

        viewController?.displayRetrievedPhoto(with: viewModel)
    }
}
