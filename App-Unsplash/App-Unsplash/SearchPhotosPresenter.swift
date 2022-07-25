//
// PresenterSearchPhotos.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

//protocol SearchPhotosPresentationLogicBi {
//    func presentSearchPhotos(with responses: [Response])
//    func interactor(didFindIdPhoto: String)
//}
protocol SearchPhotosPresentationLogic {
    func presentFetchedPhotos(with response: SearchPhotos.FetchPhotos.Response)
}

class SearchPhotosPresenter: SearchPhotosPresentationLogic {
    weak var view: SearchPhotosDisplayLogic?

    func presentFetchedPhotos(with response: SearchPhotos.FetchPhotos.Response) {
        var viewModel = SearchPhotos.FetchPhotos.ViewModel(displayedPhotos: [])

		// map response to viewmodel
        response.photos.forEach { photo in
            if let photoDescription = photo.description {
                viewModel.displayedPhotos.append(.init(description: photoDescription))
            }
        }
        view?.displayedFetchedPhotos(viewModel: viewModel)
    }

//    func interactor(didFindIdPhoto id: String) {
////        view?.presenter(didObtainPhotoID: id)
//    }
}


