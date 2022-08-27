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

    override func setUp() {
        super.setUp()
        sut = SearchPhotosViewController()
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init_SearchPhotosViewController__expect_notNil() {
        XCTAssertNotNil(sut)
    }
	// VC -> IN
     func test_searchPhotos_withRequest__expect_invokedInteractor() {
        // --- given .
        let searchPhotosInteractorSPY = SearchPhotosInteractorSPY()
        sut.interactor = searchPhotosInteractorSPY
        let request: SearchPhotos.FetchPhotos.Request = .init(query: "Car")

        // --- when.
        sut.searchPhotos(withRequest: request)

        // --- then.
        XCTAssertTrue(searchPhotosInteractorSPY.invokedInteractor)
    }

    func test_searchPhotos_withRequest__expect_rightRequestPassed() {
        // --- given .
        let searchPhotosInteractorSPY = SearchPhotosInteractorSPY()
        sut.interactor = searchPhotosInteractorSPY
        let request: SearchPhotos.FetchPhotos.Request = .init(query: "Car")

        // --- when.
        sut.searchPhotos(withRequest: request)

        // --- then.
        XCTAssertEqual("Car",searchPhotosInteractorSPY.resultRequestPassed)
    }

    func test_lazyLoading__expect_invokedWorker() {
        // scroll TableView
        // if tableView 20 - 3 == 17
        // then trigger lazyLoading
    }


    // --- UI tableview.
    func test_numberOfSection_inTableView__expect_oneSection() {
        // setup
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        guard let searchPhotosViewController = storyboard.instantiateViewController(identifier: SearchPhotosViewController.identifier) as? SearchPhotosViewController else { XCTFail("Should cast the UIVIewController"); return }

		// --- given.
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

    class Seed {
        struct Photos {
            static let car1: Array<SearchPhotos.FetchPhotos.ViewModel.DisplayedPhoto>.ArrayLiteralElement = .init(urlsmallImage: "car1", photoID: "car1", description: "car1")
            static let car2: Array<SearchPhotos.FetchPhotos.ViewModel.DisplayedPhoto>.ArrayLiteralElement = .init(urlsmallImage: "car2", photoID: "car2", description: "car2")
        }
    }

    func test_numberOfRowInAnySection__expect_EqualNumberOfPhotosFetched() {
        // setup
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        guard let searchPhotosViewController = storyboard.instantiateViewController(identifier: SearchPhotosViewController.identifier) as? SearchPhotosViewController else { XCTFail("Should cast the UIVIewController"); return }

        // --- given.
        let tableViewSPY = TableViewSPY() // mock the real tableview
        searchPhotosViewController.tableview = tableViewSPY
        XCTAssertNotNil(searchPhotosViewController.tableview)

        // Load the view of the ViewController if it is not already done, also allows to load the TableView from the Storyboard
        searchPhotosViewController.loadViewIfNeeded() // comment the next line to see the test fail


		// --- create viewModel.
        let viewModel = SearchPhotos.FetchPhotos.ViewModel(displayedPhotos: [
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


    // ==================
    // MARK: - Test doubles
    // ==================
    class SearchPhotosInteractorSPY: SearchPhotosBusinessLogic {

        var invokedInteractor: Bool!
        var resultRequestPassed: String!

        func retrivePhotos(withRequest request: SearchPhotos.FetchPhotos.Request) {
			invokedInteractor = true
            resultRequestPassed = request.query
        }
    }

    class TableViewSPY: UITableView {

    }
}
