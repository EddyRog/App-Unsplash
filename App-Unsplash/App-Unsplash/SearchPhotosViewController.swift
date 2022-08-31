//
// ViewSearchPhotos.swift
// App-Unsplash
// Created in 2022
// Swift 5.0

import Foundation
import UIKit

protocol SearchPhotosViewable: AnyObject {
    func searchPhotos(withRequest: SearchPhotos.RetrievePhotos.Request)
    func displayedFetchedPhotos(viewModel: SearchPhotos.RetrievePhotos.ViewModel)
}

class SearchPhotosViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private (set) var interactor: SearchPhotosInteractable?
    private (set) var router: SearchPhotosRoutable?
    var resultSearchPhotos: SearchPhotos.RetrievePhotos.ViewModel = .init(displayedPhotos: []) // --- TableView.
    var filteredData: [String]! = nil // --- SearchBar.


    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchPhotos(withRequest: SearchPhotos.RetrievePhotos.Request(query: "car"))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTableView()
        setupSearchBar()
    }


    func setRouter(_ searchPhotosRouter: SearchPhotosRouter) {
        router = searchPhotosRouter
    }
    func setInteractor(_ searchPhotosInteratable: SearchPhotosInteractable) {
        self.interactor = searchPhotosInteratable
    }
}

extension SearchPhotosViewController: SearchPhotosViewable {
    func searchPhotos(withRequest request: SearchPhotos.RetrievePhotos.Request) {
        interactor?.retrivePhotos(withRequest: request)
    }
    func displayedFetchedPhotos(viewModel: SearchPhotos.RetrievePhotos.ViewModel) {
        resultSearchPhotos = viewModel
        print("⭐️ ---- \(resultSearchPhotos.displayedPhotos.count)")

        DispatchQueue.main.async { [weak self] in
            guard let this = self else {return}
            this.tableview.reloadData()
        }
    }
}

extension SearchPhotosViewController: UISearchBarDelegate {
    fileprivate func setupSearchBar() {
        searchBar.delegate = self

        // configure UI
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = #colorLiteral(red: 0.1133617684, green: 0.1133617684, blue: 0.1133617684, alpha: 1).cgColor

        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: Constant.SearchPhoto.placeHolderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let textSearching = searchBar.text {
            if !textSearching.isEmpty {
                self.searchPhotos(withRequest: SearchPhotos.RetrievePhotos.Request(query: textSearching))
            }
        }
    }
}

extension SearchPhotosViewController: UITableViewDataSource, UITableViewDelegate {
    fileprivate func setupTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        registerTableViewCells()
    }
    func registerTableViewCells() {
        let idCell = Constant.SearchPhoto.idCell
        let textFieldCell = UINib(nibName: idCell, bundle: nil)
        self.tableview.register(textFieldCell, forCellReuseIdentifier: idCell)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultSearchPhotos.displayedPhotos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let idCell = Constant.SearchPhoto.idCell
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell) as? SearchPhotosCell

        if let unwCell = cell {
            let description = resultSearchPhotos.displayedPhotos[indexPath.row].description
            let images = resultSearchPhotos.displayedPhotos[indexPath.row].urlsmallImage

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
        let photoID = resultSearchPhotos.displayedPhotos[indexPath.row].photoID
        // get id
        router?.rootToShowPhoto(withID: photoID)
    }

//    shouldHighlightRowAt
    // TODO: ❎ LazyLoading ❎
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if resultSearchPhotos.displayedPhotos.count - 3 == indexPath.row {
            print(indexPath.row)
            print("max", resultSearchPhotos.displayedPhotos.count)
        }
    }
}

extension SearchPhotosViewable {
    func makePicture(with url: String) -> Data {
        let defaultData = UIImage(named: Constant.SearchPhoto.defaultImageName)?.pngData() ?? Data()
        guard let url = URL(string: url) else {
            return defaultData
        }
        let result = try? Data(contentsOf: url)
        return result ?? defaultData
    }
}

// FIXME: ⚠️ to remove : duplicated ⚠️
struct Helper {
    static func makePicture(with url: String) -> Data {
        let defaultData = UIImage(named: Constant.SearchPhoto.defaultImageName)?.pngData() ?? Data()
        guard let url = URL(string: url) else {
            return defaultData
        }
        let result = try? Data(contentsOf: url)
        return result ?? defaultData
    }
}
