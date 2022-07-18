//
// ViewSearchPhotos.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation
import UIKit

protocol SearchPhotosView: AnyObject {
    func display(with viewModel: [ViewModel])
}

class SearchPhotosViewImpl: UIViewController {
    @IBOutlet weak var test: UILabel!

    static let identifier: String = "SearchPhotosViewImpl"
    var interactor: SearchPhotosInteractor?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchPhotos(with: "car")
    }

    func parseResponse(data: Data) throws -> [Response] {
        let decoder = JSONDecoder()
        var responses = [Response]()
        do {
            let responseData = try decoder.decode(UnsplashObjc.self, from: data)
            responseData.photos.results.forEach { result in
                let response = Response(description: result.description)
                responses.append(response)
            }

            return responses
        } catch {
            throw ServiceError.dataParse
        }
    }

    func searchPhotos(with request: String) {
        interactor?.searchPhotos(with: request)
    }
}

extension SearchPhotosViewImpl: SearchPhotosView {
    func display(with viewModel: [ViewModel]) {
        // MARK: - set outlet
        DispatchQueue.main.async { [weak self] in
            self?.test.text = viewModel.last?.description
        }
    }
}
