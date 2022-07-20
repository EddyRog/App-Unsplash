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
    @IBOutlet weak var tableview: UITableView!

    var interactor: SearchPhotosInteractor?
    var router: SearchPhotosRouter?

    static let identifier: String = "SearchPhotosViewImpl"
    var resultSearch: [ViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self

        registerTableViewCells()
        searchPhotos(with: "car")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    func searchPhotos(with request: String) {
        interactor?.searchPhotos(with: request)
    }

    @IBAction func push(_ sender: Any) {
        print("push")
        router?.showSearchPhotoDetails()
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
            self?.tableview.reloadData()
        }
    }
}

// ==================
// MARK: - Tableview result
// ==================
extension SearchPhotosViewImpl: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultSearch.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idCell = "SearchPhotosCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell) as? SearchPhotosCell


        if let unwCell = cell {

            let dataImageString = resultSearch[indexPath.row].urlSmall ?? ""
            unwCell.searchPhotoImage.image = UIImage(data: makePicture(with: dataImageString))
            unwCell.searchPhotoDescription.text = resultSearch[indexPath.row].description

            return unwCell
        } else {
            let cellDefault: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: idCell)
            var content = cellDefault.defaultContentConfiguration()
            content.text = "nil"

            cellDefault.contentConfiguration = content

            return cellDefault
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("dee L\(#line) 🏵 -------> index => ", indexPath)
//        debugPrint("dee L\(#line) 🏵 -------> index => ", resultSearch[indexPath.row].description)
		
        // clique
        // select id
        // interactor.fetchPhoto(with id)

        // TODO: ❎ pass id from resultSearch ❎
        interactor?.searchPhotosIndexPath(indexPath)
        	// worker
        		// service
        // save data photo in store
        // presenter
        // view
        // rout to detail et pass data
        // configurator.make
        // 
//        router?.showSearchPhotoDetails()
    }

    func registerTableViewCells() {
		let idCell = "SearchPhotosCell"
        let textFieldCell = UINib(nibName: idCell, bundle: nil)
        self.tableview.register(textFieldCell, forCellReuseIdentifier: idCell)
    }
}

extension SearchPhotosView {
    func makePicture(with url: String) -> Data {
        let defaultData = UIImage(named: "noPicture")?.pngData() ?? Data()
        guard let url = URL(string: url) else {
            return defaultData
        }
        let result =  try? Data(contentsOf: url)
		return result ?? defaultData
    }
}



