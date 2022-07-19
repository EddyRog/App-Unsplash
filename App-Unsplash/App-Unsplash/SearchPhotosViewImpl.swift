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
        registerTableViewCells()
        searchPhotos(with: "car")
    }

    func parseResponse(data: Data) throws -> [Response] {
        let decoder = JSONDecoder()
        let responses = [Response]()
        do {
            _ = try decoder.decode(UnsplashObjc.self, from: data)
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
        let idCell = "SearchPhotosCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell) as? SearchPhotosCell


        if let unwCell = cell {
            cell?.searchPhotoDescription.text = resultSearch[indexPath.row].description

            let dataImageString = "https://images.unsplash.com/photo-1526121846098-84e5d2e3437b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=Mnw1NDcwN3wwfDF8c2VhcmNofDF8fGNhcnJ8ZW58MHx8fHwxNjU2OTQxNDE4&ixlib=rb-1.2.1&q=80&w=400"
            let urlImage = URL(string: dataImageString)
            _ = try? Data.init(contentsOf: urlImage!)
//            unwCell.searchPhotoImage.image = UIImage(data: dataImage!)
            unwCell.searchPhotoImage.image = UIImage(data: dataImageString.data(using: .utf8)!)

            return unwCell
        } else {
            let cellDefault: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: idCell)
            var content = cellDefault.defaultContentConfiguration()
            content.text = "nil"

            cellDefault.contentConfiguration = content

            return cellDefault
        }
    }

    func registerTableViewCells() {
		let idCell = "SearchPhotosCell"
        let textFieldCell = UINib(nibName: idCell, bundle: nil)
        self.resultTableView.register(textFieldCell, forCellReuseIdentifier: idCell)
    }
}

extension SearchPhotosView {

    func makePicture(with url: String) -> Data {
        let defaultData = UIImage(named: "noPicture")?.pngData() ?? Data()
        guard let url = URL(string: url) else { return defaultData }
        let result =  try? Data(contentsOf: url)
		return result ?? defaultData
    }

}



