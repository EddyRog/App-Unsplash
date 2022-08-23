//
// PresenterSearchPhotos.swift
// App-Unsplash
// Created in 2022
// Swift 5.0

import Foundation

protocol SearchPhotosPresentationLogic {
    func presentFetchedPhotos(with response: SearchPhotos.FetchPhotos.Response)
}

class SearchPhotosPresenter: SearchPhotosPresentationLogic {

    weak var viewController: SearchPhotosDisplayLogic?

    func presentFetchedPhotos(with response: SearchPhotos.FetchPhotos.Response) {
        var viewModel = SearchPhotos.FetchPhotos.ViewModel(displayedPhotos: [])

		// map response to viewmodel
        response.photos.forEach { photo in

            let urlsmallImage = photo.urlsmallImage ?? ""
            let description = photo.description ?? ""
            let photoID = photo.photoID

            let displayedPhoto: SearchPhotos.FetchPhotos.ViewModel.DisplayedPhoto = .init(
                urlsmallImage: urlsmallImage,
                photoID: photoID,
                description: description)

            viewModel.displayedPhotos.append(displayedPhoto)

//            if let photoDescription = photo.description {
//                viewModel.displayedPhotos.append(.init(
//                    photoID: photo.photoID,
//                    description: photoDescription
//                ))
//            }
        }
        viewController?.displayedFetchedPhotos(viewModel: viewModel)
    }
}
