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
    func loadNextPageOfPhoto()
    func displayedFetchedPhotosOnNextPage(viewModel: SearchPhotos.RetrievePhotos.ViewModel)
}

class SearchPhotosViewController: UIViewController {

    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    private (set) var interactor: SearchPhotosInteractable?
    private (set) var router: SearchPhotosRoutable?
    var resultSearchPhotos: SearchPhotos.RetrievePhotos.ViewModel = .init(displayedPhotos: []) // --- TableView.
    private var lastTextSearched: String = "Car"
    private var currentPage: String?
    private var nextPageNoTrigger = true


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
    // SearchPhotosViewable IN
    func searchPhotos(withRequest request: SearchPhotos.RetrievePhotos.Request) {
        interactor?.retrivePhotos(withRequest: request)
    }
    func loadNextPageOfPhoto() {
        let request = SearchPhotos.RetrievePhotos.Request(query: lastTextSearched, currentPage: currentPage)
        interactor?.retrievePhotosOnNextPage(withRequest: request)
    }

    // SearchPhotosViewable OUT
    func displayedFetchedPhotos(viewModel: SearchPhotos.RetrievePhotos.ViewModel) {
        resultSearchPhotos = viewModel

        DispatchQueue.main.async { [weak self] in
            guard let this = self else { return }
            this.tableview.reloadData()
        }
    }

    func displayedFetchedPhotosOnNextPage(viewModel: SearchPhotos.RetrievePhotos.ViewModel) {
        // update current page
        let incrementPageBy = 1
        let defaultPage = "2"

        // switch to the next page
        if let currentP = currentPage {
            if let valueCurrenP = Int(currentP) {
                currentPage = String(valueCurrenP + incrementPageBy)
            } else {
                currentPage = defaultPage
            }
        } else {
            currentPage = defaultPage
        }

        // --- update dataSource.
        resultSearchPhotos.displayedPhotos.append(contentsOf: viewModel.displayedPhotos)

        DispatchQueue.main.async { [weak self] in
            // update ui
            self?.tableview.reloadData()
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
                self.lastTextSearched = textSearching
                self.currentPage = nil
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

            unwCell.searchPhotoImage.image = UIImage(data: Helper.makePicture(with: images))
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
        let photoID = resultSearchPhotos.displayedPhotos[indexPath.row].photoID
        router?.rootToShowPhoto(withID: photoID)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1

        let numberOfCellBeforeReloading = 5
        let lastRowIndex = (tableView.numberOfRows(inSection: lastSectionIndex) - numberOfCellBeforeReloading)

        if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex)) && nextPageNoTrigger {
            loadNextPageOfPhoto()
        }
    }
}
