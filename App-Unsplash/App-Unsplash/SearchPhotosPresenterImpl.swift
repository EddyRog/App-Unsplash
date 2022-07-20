//
// PresenterSearchPhotos.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

protocol SearchPhotosPresenter {
    func presentSearchPhotos(with responses: [Response])
    func interactor(didFindIdPhoto: String)
}

class SearchPhotosPresenterImpl: SearchPhotosPresenter {
    weak var view: SearchPhotosView?

    func presentSearchPhotos(with responses: [Response]) {
		var viewModels = [ViewModel]()

        responses.forEach { response in
            let viewModel = ViewModel(
                description: response.description,
                urlSmall: response.urlSmall
            )
            viewModels.append(viewModel)
        }

		// send back viewModel
        view?.display(with: viewModels)
    }

    func interactor(didFindIdPhoto: String) {
        
    }
}
