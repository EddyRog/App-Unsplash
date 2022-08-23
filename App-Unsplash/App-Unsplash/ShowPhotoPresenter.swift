//
// ShowPhotoPresenter.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

protocol ShowPhotoPresentationLogic {
    func presentRetrievePhoto(with response: ShowPhoto.FetchPhoto.Response)
}

class ShowPhotoPresenter: ShowPhotoPresentationLogic {
    weak var viewController: ShowPhotoViewController?

    func presentRetrievePhoto(with response: ShowPhoto.FetchPhoto.Response) { }
}
