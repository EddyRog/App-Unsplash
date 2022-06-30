//
// PresenterSearchPhotos.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

protocol PresenterSearchPhotos { }
class PresenterSearchPhotosImpl {
    var view: ViewSearchPhotos?

    func present(with responses: Response) {
        var viewModels: [ViewModel] = []
        // parse responses
        responses.value.forEach { photo in
            // extract data from each object
            let description = photo.description
            let picture = photo.picture

            // hydrate viewModel with data extracted
            let viewModelHydrated = ViewModel(description: description, thumbsUrlImage: picture)

            viewModels.append(viewModelHydrated)
        }
        // send back to the view
        view?.display(with: viewModels)
    }
}


