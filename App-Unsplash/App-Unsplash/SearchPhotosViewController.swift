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

    var resultSearchPhotos: SearchPhotos.FetchPhotos.ViewModel = .init(displayedPhotos: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        registerTableViewCells()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        if let nav = self.navigationController {
//            guard let showPhotoViewController = try? ShowPhotoConfigurator(navController: nav, withIDPhoto: "idPhoto").createModule() else { return }
//            showPhotoViewController.loadViewIfNeeded()
//            nav.pushViewController(showPhotoViewController, animated: true)
//        }

        searchPhotos(withRequest: SearchPhotos.FetchPhotos.Request(query: "car"))
    }
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

// ==================
// MARK: - Tableview
// ==================
extension SearchPhotosViewController: UITableViewDataSource, UITableViewDelegate {
    func registerTableViewCells() {
        let idCell = "SearchPhotosCell"
        let textFieldCell = UINib(nibName: idCell, bundle: nil)
        self.tableview.register(textFieldCell, forCellReuseIdentifier: idCell)
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
