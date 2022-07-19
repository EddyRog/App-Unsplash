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

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var resultTableView: UITableView!
    var resultSearch: [ViewModel] = []

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
//            responseData.photos.results.forEach { result in
//                let response = Response(description: result.description)
//                responses.append(response)
//            }

            return responses
        } catch {
            throw ServiceError.dataParse
        }
    }

    func searchPhotos(with request: String) {
        interactor?.searchPhotos(with: request)
    }

    @IBAction func actionSearch(_ sender: Any) {
        let request = searchTextField.text
        debugPrint("dee L\(#line) 🏵 -------> request txtfield => ", request)
        guard let unwRequest = request else { return }
        interactor?.searchPhotos(with: unwRequest)
    }
}

extension SearchPhotosViewImpl: SearchPhotosView {
    func display(with viewModel: [ViewModel]) {
        // MARK: - set outlet
        DispatchQueue.main.async { [weak self] in
//            self?.test.text = viewModel.last?.description
            self?.resultSearch = viewModel
            self?.resultTableView.reloadData()
        }
    }
}

// ==================
// MARK: - Tableview result
// ==================
extension SearchPhotosViewImpl: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultSearch.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idCell = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell)

        if let unwCell = cell {
            var content = unwCell.defaultContentConfiguration()
            content.text = resultSearch[indexPath.row].description
            content.textProperties.color = .white
            content.textProperties.font = .systemFont(ofSize: 20)

            unwCell.contentConfiguration = content

            return unwCell
        } else {
            let cellDefault: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: idCell)
            var content = cellDefault.defaultContentConfiguration()
            content.text = "nil"

            cellDefault.contentConfiguration = content

            return cellDefault
        }
    }

}



