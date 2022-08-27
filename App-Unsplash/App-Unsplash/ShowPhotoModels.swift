//
// ShowPhotoModels.swift
// App-Unsplash
// Created in 2022
// Swift 5.0

import Foundation

enum ShowPhoto {
    enum FetchPhoto {
        struct Request {
            var query: String
        }
        struct Response: Equatable {
            var photo: Photo?
        }
        struct ViewModel: Equatable {
            struct DisplayedPhoto: Equatable {
                var urlsmallImage: String?
                var photoID: String?
                var description: String
                var username: String?

                static func == (lhs: ShowPhoto.FetchPhoto.ViewModel.DisplayedPhoto, rhs: ShowPhoto.FetchPhoto.ViewModel.DisplayedPhoto) -> Bool {
                    return lhs.urlsmallImage == rhs.urlsmallImage &&
                    lhs.photoID == rhs.photoID &&
                    lhs.description == rhs.description &&
                    lhs.username == rhs.username
                }
            }
            var displayedPhoto: DisplayedPhoto

            static func == (lhs: ShowPhoto.FetchPhoto.ViewModel, rhs: ShowPhoto.FetchPhoto.ViewModel) -> Bool {
                return lhs.displayedPhoto == rhs.displayedPhoto
            }
        }
    }
}
