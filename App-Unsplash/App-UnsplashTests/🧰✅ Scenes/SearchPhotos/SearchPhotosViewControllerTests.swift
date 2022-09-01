////
//// SearchPhotosViewControllerTests.swift
//// App-UnsplashTests
//// Created in 2022
//// Swift 5.0
//
@testable import App_Unsplash
import XCTest
import CustomDump

class SearchPhotosViewControllerTests: XCTestCase {

    var sut: SearchPhotosViewController!
    var searchPhotosInteractorSPY: SearchPhotosInteractorSPY!

    override func setUp() {
        super.setUp()
        sut = SearchPhotosViewController()
        searchPhotosInteractorSPY = SearchPhotosInteractorSPY()
        sut.setInteractor(searchPhotosInteractorSPY)
    }
    override func tearDown() {
        sut = nil
        searchPhotosInteractorSPY = nil

        super.tearDown()
    }

    
    // VC -> IN
    func test_searchPhotos_withRequest__expect_invokedInteractor() {
    // --- given .
    let searchPhotosInteractorSPY = SearchPhotosInteractorSPY()
    sut.setInteractor(searchPhotosInteractorSPY)

    let request: SearchPhotos.RetrievePhotos.Request = .init(query: "Car")

    // --- when.
    sut.searchPhotos(withRequest: request)

    // --- then.
    XCTAssertTrue(searchPhotosInteractorSPY.invokedInteractor)
}

    func test_searchPhotos_withRequest__expect_rightRequestPassed() {
        // --- given .
        let searchPhotosInteractorSPY = SearchPhotosInteractorSPY()
        sut.setInteractor(searchPhotosInteractorSPY)
//        sut.interactor = searchPhotosInteractorSPY
        let request: SearchPhotos.RetrievePhotos.Request = .init(query: "Car")

        // --- when.
        sut.searchPhotos(withRequest: request)

        // --- then.
        XCTAssertEqual("Car",searchPhotosInteractorSPY.resultRequestPassed)
    }

//    func test_loadNextPage_withRequest__expect_invokedInteractor() {
//        let request: SearchPhotos.RetrievePhotos.Request = .init(
//            query: "car",
//            currentPage: "2"
//        )
//
//        sut.searchPhotosOnNextPage(withRequest: request)
//
//        XCTAssertTrue(searchPhotosInteractorSPY.invokedInteractor)
//        assertNoDifference(1, searchPhotosInteractorSPY.invokedRetrivePhotosCount)
//        assertNoDifference("2", searchPhotosInteractorSPY.resultRequestPage)
//    }

    // LoadNextPage
    func test_loadNextPage__expect_invokedInteractor() {
        sut.loadNextPageOfPhoto()

        XCTAssertTrue(searchPhotosInteractorSPY.invokedLoadNextPageOfPhotos)
    }



    // --- UI tableview.
    func test_numberOfSection_inTableView__expect_oneSection() {
        // setup
        guard let searchPhotosViewController = setupSearchViewController() else {
            XCTFail("Should return an instance of SearchViewController")
            return
        }

        // --- setup TableViewSPY.
        let tableViewSPY = TableViewSPY() // mock the real tableview
        searchPhotosViewController.tableview = tableViewSPY
        XCTAssertNotNil(searchPhotosViewController.tableview)

        // Load the view of the ViewController if it is not already done, also allows to load the TableView from the Storyboard
        searchPhotosViewController.loadViewIfNeeded() // comment the next line to see the test fail

        // --- when.
        let numberOfSection = searchPhotosViewController.tableview.numberOfSections

        // --- then.
        XCTAssertEqual(1, numberOfSection)
    }

    func test_numberOfRowInAnySection__expect_EqualNumberOfPhotosFetched() {
        // setup
        guard let searchPhotosViewController = setupSearchViewController() else {
            XCTFail("Should return an instance of SearchViewController")
            return
        }

        // --- given.
        let tableViewSPY = TableViewSPY() // mock the real tableview
        searchPhotosViewController.tableview = tableViewSPY
        XCTAssertNotNil(searchPhotosViewController.tableview)

        // Load the view of the ViewController if it is not already done, also allows to load the TableView from the Storyboard
        searchPhotosViewController.loadViewIfNeeded() // comment the next line to see the test fail

		// --- create viewModel.
        let viewModel = SearchPhotos.RetrievePhotos.ViewModel(displayedPhotos: [
            Seed.Photos.car1,
            Seed.Photos.car2,
        ])
        // --- set data of tableview.
        searchPhotosViewController.resultSearchPhotos = viewModel

        // --- when.
        let actualNumberOfRows = searchPhotosViewController.tableview.numberOfRows(inSection: 0) // numbers of row in the section 0

        // --- then.
        assertNoDifference(viewModel.displayedPhotos.count, actualNumberOfRows)
    }

    func test_shouldConfigure_tableView__expect_tableViewCell_toDisplayPhoto() {
        // setup
        guard let searchPhotosViewController = setupSearchViewController() else {
            XCTFail("Should return an instance of SearchViewController")
            return
        }

        // --- given.
        // MARK: - configure Tableview
        let tableViewSPY = TableViewSPY() // mock the real tableview
        searchPhotosViewController.tableview = tableViewSPY
        XCTAssertNotNil(searchPhotosViewController.tableview)

        // MARK: - configure CustomCell
        let idCell = "SearchPhotosCell"
        let textFieldCell = UINib(nibName: idCell, bundle: nil)
        searchPhotosViewController.tableview.register(textFieldCell, forCellReuseIdentifier: idCell)

        // MARK: - Load the view From its storyboard
        // Load the view of the ViewController if it is not already done, also allows to load the TableView from the Storyboard
        searchPhotosViewController.loadViewIfNeeded() // comment the next line to see the test fail

        // --- create viewModel.
        let viewModel = SearchPhotos.RetrievePhotos.ViewModel(displayedPhotos: [
            Seed.Photos.car1,
            Seed.Photos.car2,
        ])
        // --- set data of tableview.
        searchPhotosViewController.resultSearchPhotos = viewModel

        // --- when.
        let indexPath: IndexPath = IndexPath(row: 0, section: 0)
        let cell = searchPhotosViewController.tableView(tableViewSPY, cellForRowAt: indexPath)
        guard let searchPhotoCell = cell as? SearchPhotosCell else {
            XCTFail("Should cast the cell to SearchPhotoCell")
            return
        }

        XCTAssertEqual("Car01", searchPhotoCell.searchPhotoDescription.text)
    }


    // ==================
    // MARK: - Test doubles
    // ==================
    class SearchPhotosInteractorSPY: SearchPhotosInteractable {
        var invokedInteractor: Bool!
        var invokedRetrivePhotosCount = 0
        var resultRequestPassed: String!
        var resultRequestPage: String!
        var invokedLoadNextPageOfPhotos: Bool!

        func retrivePhotos(withRequest request: SearchPhotos.RetrievePhotos.Request) {
			invokedInteractor = true
            invokedRetrivePhotosCount += 1
            resultRequestPassed = request.query
            resultRequestPage = request.currentPage
        }
        func retrievePhotosOnNextPage(withRequest: SearchPhotos.RetrievePhotos.Request) {
            invokedLoadNextPageOfPhotos = true
        }
    }

    class TableViewSPY: UITableView { }

    class Seed {
        struct Photos {
            static let car1: Array<SearchPhotos.RetrievePhotos.ViewModel.DisplayedPhoto>.ArrayLiteralElement = .init(urlsmallImage: "Car01", photoID: "Car01", description: "Car01")
            static let car2: Array<SearchPhotos.RetrievePhotos.ViewModel.DisplayedPhoto>.ArrayLiteralElement = .init(urlsmallImage: "Car02", photoID: "Car02", description: "Car02")
        }
    }

    private func setupSearchViewController() -> SearchPhotosViewController? {
        // init
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        guard let searchPhotosViewController = storyboard.instantiateViewController(identifier: Constant.SearchPhoto.identifierViewController) as? SearchPhotosViewController else {
            XCTFail("Should cast the UIVIewController")
            return nil
        }

        return searchPhotosViewController
    }
}
