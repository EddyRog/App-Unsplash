//
// ViewSearchPhotos.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation
import UIKit


protocol SearchPhotosDisplayLogic: AnyObject {
    func searchPhotos(withRequest: SearchPhotos.FetchPhotos.Request)
    func displayedFetchedPhotos(viewModel: SearchPhotos.FetchPhotos.ViewModel)
}

class SearchPhotosViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableview: UITableView!

    var interactor: SearchPhotosBusinessLogic?
    var router: SearchPhotosRoutingLogic?

    static let identifier: String = "SearchPhotosViewImpl"
    var resultSearch: [ViewModel] = []
    var resultSearchPhotos: SearchPhotos.FetchPhotos.ViewModel = .init(displayedPhotos: [
        .init(description: "--")
    ])

    override func viewDidLoad() {
        super.viewDidLoad()
        print("📘")
        tableview.delegate = self
        tableview.dataSource = self

        registerTableViewCells()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchPhotos(withRequest: SearchPhotos.FetchPhotos.Request(query: "car"))
    }

    @IBAction func push(_ sender: Any) {
        print("push")
//        router?.showSearchPhotoDetails()
    }

    @IBAction func actionSearch(_ sender: Any) {
//        let request = searchTextField.text
//        debugPrint("dee L\(#line) 🏵 -------> request txtfield => ", request)
//        guard let unwRequest = request else { return }
//        interactor?.searchPhotos(with: unwRequest)
    }
}

extension SearchPhotosViewController: SearchPhotosDisplayLogic {

    func searchPhotos(withRequest request: SearchPhotos.FetchPhotos.Request) {
        interactor?.fetchPhotos(withRequest: request)
    }

    func displayedFetchedPhotos(viewModel: SearchPhotos.FetchPhotos.ViewModel) {
        resultSearchPhotos = viewModel
        tableview.reloadData()
    }
}

//extension SearchPhotosViewController: SearchPhotosDisplayLogic {

//    func display(with viewModel: [ViewModel]) {
//        // MARK: - set outlet
//        DispatchQueue.main.async { [weak self] in
////            self?.test.text = viewModel.last?.description
//            self?.resultSearch = viewModel
//            self?.tableview.reloadData()
//        }
//    }

//    func presenter(didObtainPhotoID id: String) {
//        router?.rootToSearchPhotosDetails(withID: id)
//    }
//}


// ==================
// MARK: - Tableview
// ==================
extension SearchPhotosViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultSearchPhotos.displayedPhotos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let idCell = "SearchPhotosCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell) as? SearchPhotosCell

        if let unwCell = cell {
            let description = resultSearchPhotos.displayedPhotos[indexPath.row].description
            let images = resultSearchPhotos.displayedPhotos[indexPath.row].description

            unwCell.searchPhotoImage.image = UIImage(data: makePicture(with: images))
            unwCell.searchPhotoDescription.text = description

            return unwCell
        } else {
            let cellDefault: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: idCell)
            var content = cellDefault.defaultContentConfiguration()
            content.text = "no description"

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

        // ODO: ❎ pass id from resultSearch ❎
//        interactor?.searchPhotosIndexPath(indexPath)
        // worker
        // service
        // save data photo in store
        // presenter
        // view
        // rout to detail et pass data
        // configurator.make
        //
//        router?.showSearchPhotoDetails()

        router?.rootToSearchPhotosDetails(withID: "\(indexPath.row)")
    }

    func registerTableViewCells() {
        let idCell = "SearchPhotosCell"
        let textFieldCell = UINib(nibName: idCell, bundle: nil)
        self.tableview.register(textFieldCell, forCellReuseIdentifier: idCell)
    }
}

extension SearchPhotosDisplayLogic {
    func makePicture(with url: String) -> Data {
        let defaultData = UIImage(named: "noPicture")?.pngData() ?? Data()
        guard let url = URL(string: url) else {
            return defaultData
        }
        let result = try? Data(contentsOf: url)
        return result ?? defaultData
    }
}
