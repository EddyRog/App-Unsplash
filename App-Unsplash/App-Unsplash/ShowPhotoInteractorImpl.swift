//
// ShowPhotoInteractorImpl.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation
protocol ShowPhotoInteractor {
    func getPhoto(width id: String)
}
class ShowPhotoInteractorImpl: ShowPhotoInteractor {
    var presenter: ShowPhotoPresenter?
    func getPhoto(width id: String) {
        presenter?.presentPhoto(with: .init(photo: Photo()))
    }
}
