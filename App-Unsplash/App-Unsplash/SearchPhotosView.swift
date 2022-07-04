//
// ViewSearchPhotos.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation

protocol SearchPhotosView {
    func display(with viewModels: [ViewModel])
}

class SearchPhotosViewImpl: SearchPhotosView {
    var interactor: SearchPhotosInteractorImpl?
    func display(with viewModels: [ViewModel]) { }
}
