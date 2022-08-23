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
        struct ViewModel {
            struct DisplayedPhoto {
                var description: String
            }
            var displayedPhotos: DisplayedPhoto
        }
    }
}
