//
// ShowPhotoPresenterImpl.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

protocol ShowPhotoPresenter {
    func presentPhoto(with response: ShowPhoto.GetPhoto.Response)
}

class ShowPhotoPresenterImpl: ShowPhotoPresenter {
    weak var view: ShowPhotoView?

    func presentPhoto(with response: ShowPhoto.GetPhoto.Response) {
        // map to viewModel
        let viewModel = ShowPhoto.GetPhoto.ViewModel.init(displayedPhoto: ShowPhoto.GetPhoto.ViewModel.DisplayedPhoto.init(description: "description"))
        view?.displayPhoto(with: viewModel)
    }
}

enum ShowPhoto {
    enum GetPhoto {
        struct Response: Equatable {
            var photo: Photo

            static func == (lhs: ShowPhoto.GetPhoto.Response, rhs: ShowPhoto.GetPhoto.Response) -> Bool {
                return lhs.photo == rhs.photo
            }
        }
        struct ViewModel {
            struct DisplayedPhoto {
                var description: String
            }
            var displayedPhoto: DisplayedPhoto
        }
    }
}

struct Photo: Equatable {
    var description: String?

    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.description == rhs.description
    }
}
