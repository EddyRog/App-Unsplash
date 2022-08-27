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

    static let identifier: String = "SearchPhotosViewController"

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var interactor: SearchPhotosBusinessLogic?
    var router: SearchPhotosRoutingLogic?

    // --- TableView.
    var resultSearchPhotos: SearchPhotos.FetchPhotos.ViewModel = .init(displayedPhotos: [])

    // --- SearchBar.
    var filteredData: [String]! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchPhotos(withRequest: SearchPhotos.FetchPhotos.Request(query: "car"))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTableView()
        setupSearchBar()
    }

    // ==================
    // MARK: - Search
    // ==================
}

extension SearchPhotosViewController: SearchPhotosDisplayLogic {
    func searchPhotos(withRequest request: SearchPhotos.FetchPhotos.Request) {
        interactor?.retrivePhotos(withRequest: request)
    }

    func displayedFetchedPhotos(viewModel: SearchPhotos.FetchPhotos.ViewModel) {
        resultSearchPhotos = viewModel

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

        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search Photos likes car or cat", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }

    // filter
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let textSearching = searchBar.text {
            if !textSearching.isEmpty {
                self.searchPhotos(withRequest: SearchPhotos.FetchPhotos.Request(query: textSearching))
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
        let idCell = "SearchPhotosCell"
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

        let idCell = "SearchPhotosCell"
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
}

extension SearchPhotosDisplayLogic {
    func makePicture(with url: String) -> Data {
        let defaultData = UIImage(named: "Image")?.pngData() ?? Data()
        guard let url = URL(string: url) else {
            return defaultData
        }
        let result = try? Data(contentsOf: url)
        return result ?? defaultData
    }
}

struct Helper {
    static func makePicture(with url: String) -> Data {
        let defaultData = UIImage(named: "Image")?.pngData() ?? Data()
        guard let url = URL(string: url) else {
            return defaultData
        }
        let result = try? Data(contentsOf: url)
        return result ?? defaultData
    }
}
