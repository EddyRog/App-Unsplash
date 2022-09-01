//
// PresenterSearchPhotos.swift
// App-Unsplash
// Created in 2022
// Swift 5.0

import Foundation

protocol SearchPhotosPresentable {
    func presentFetchedPhotos(with response: SearchPhotos.RetrievePhotos.Response)
    func presentRetrievedPhotosOnNextPage(with response: SearchPhotos.RetrievePhotos.Response)
}

class SearchPhotosPresenter: SearchPhotosPresentable {

    private (set) weak var viewController: SearchPhotosViewable?

    init(viewController: SearchPhotosViewable) {
        self.viewController = viewController
    }


    func presentFetchedPhotos(with response: SearchPhotos.RetrievePhotos.Response) {
        var viewModel = SearchPhotos.RetrievePhotos.ViewModel(displayedPhotos: [])

		// map response to viewmodel
        response.photos.forEach { photo in

            let urlsmallImage = photo.urlsmallImage ?? ""
            let description = photo.description ?? ""
            let photoID = photo.photoID

            let displayedPhoto: SearchPhotos.RetrievePhotos.ViewModel.DisplayedPhoto = .init(
                urlsmallImage: urlsmallImage,
                photoID: photoID,
                description: description)

            viewModel.displayedPhotos.append(displayedPhoto)

        }
        viewController?.displayedFetchedPhotos(viewModel: viewModel)
    }
    func presentRetrievedPhotosOnNextPage(with response: SearchPhotos.RetrievePhotos.Response) {
        var viewmodels: SearchPhotos.RetrievePhotos.ViewModel = .init(displayedPhotos: [])

        response.photos.forEach { photo in
            let displauedViewModel = SearchPhotos.RetrievePhotos.ViewModel.DisplayedPhoto(
                urlsmallImage: photo.urlsmallImage ?? "",
                photoID: photo.photoID,
                description: photo.description ?? ""
            )
            viewmodels.displayedPhotos.append(displauedViewModel)

        }

        viewController?.displayedFetchedPhotosOnNextPage(viewModel: viewmodels)
    }
}
