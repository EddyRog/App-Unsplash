//
// SearchPhotosViewTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest
import CustomDump

class SearchPhotosViewTests: XCTestCase {
    var sutViewController: SearchPhotosViewController!
    var routerSpy: RouterSpy!
    var interactorSpy: SearchPhotosBusinessLogicSpy!

    override func setUp() {
        super.setUp()
        sutViewController = SearchPhotosViewController()
        routerSpy = RouterSpy()
        interactorSpy = SearchPhotosBusinessLogicSpy()

        // setup
        sutViewController.router = routerSpy
        sutViewController.interactor = interactorSpy
    }

    override func tearDown() {
        sutViewController = nil
        super.tearDown()
    }

    func test_initViewController_expect_notNil() {
        XCTAssertNotNil(sutViewController)
    }
    func test_initViewController_expect_routerNotNil() {
        XCTAssertNotNil(sutViewController.router)
    }
    func test_initViewController_expect_interactorNotNil() {
        XCTAssertNotNil(sutViewController.interactor)
    }

    // --- search.
    func test_searchPhotos_withRequest__expect_interactorInvoked() {
        let request = SearchPhotos.FetchPhotos.Request.init(query: "car")

        sutViewController.searchPhotos(withRequest: request)

        XCTAssertTrue(interactorSpy.invokedSearchPhotos)
    }

    // --- routing.

    // --- View.
    func test_displayFetchedPhotosInvoked() {
        // --- setup.
        guard let sut = setupSut() else { XCTFail("Should return an instance of SearchViewController"); return  }
        XCTAssertNotNil(sut)

        // --- given.
        let photos: [SearchPhotos.FetchPhotos.ViewModel.DisplayedPhoto] = []
        let viewModel = SearchPhotos.FetchPhotos.ViewModel(displayedPhotos: photos)

        // provide a spy to replace the real UITableView
        let tableviewSpy = TableViewSpy()
        sut.tableview = tableviewSpy

        // --- when.
        sut.displayedFetchedPhotos(viewModel: viewModel)

		// --- when.
        XCTAssertTrue(tableviewSpy.invokedReloadDataInvoked, "displayedFetchedPhotos should reload the table view")
    }
    func test_numberOfSectionInTableView__expect_one() {
        // --- setup.
        guard let sut = setupSut() else { XCTFail("Should return an instance of SearchViewController"); return  }

		// --- given.
        // provide a spy to replace the real UITableView
        let tableviewSpy = TableViewSpy()
        sut.tableview = tableviewSpy

        // --- when.
        let numberOfSection = sut.tableview.numberOfSections

        // --- then.
        assertNoDifference(numberOfSection, 1)
    }
    func test_numberOfRowInAnySection__expect_shouldEqualNumberOfPhotosFetched() {
        // --- setup.
        guard let sut = setupSut() else { XCTFail("Should return an instance of SearchViewController"); return  }

        // Load the view of the ViewController if it is not done and also allows to load the TableView from the Storyboard
        sut.loadViewIfNeeded()
        XCTAssertNotNil(sut.tableview)

        // --- given.
        let viewModel = SearchPhotos.FetchPhotos.ViewModel(displayedPhotos: [
            .init(description: Seed.Photos.paris.description!),
            .init(description: Seed.Photos.nice.description!),
        ])
        sut.resultSearchPhotos = viewModel // set the result for tableview

        // --- when.
        let actualNumberOfRows = sut.tableview.numberOfRows(inSection: 0)

        // --- then.
        assertNoDifference(viewModel.displayedPhotos.count, actualNumberOfRows)
    }
    func test_shouldConfigure_tableView__expect_tableViewCell_toDisplayPhoto() {

        // --- setup.
        guard let sut = setupSut() else { XCTFail("Should return an instance of SearchViewController"); return  }
        sut.loadViewIfNeeded()

        // --- given.
        sut.resultSearchPhotos = .init(displayedPhotos: [
            .init(description: "Paris"),
            .init(description: "Japon")
        ])

        print(sut.resultSearchPhotos)

        // --- when.
        guard let cell = sut.tableView(sut.tableview, cellForRowAt: IndexPath(row: 0, section: 0)) as? SearchPhotosCell else {
            return XCTFail("Should cast the cell")
        }
        assertNoDifference("Paris", cell.searchPhotoDescription.text)

        guard let cell = sut.tableView(sut.tableview, cellForRowAt: IndexPath(row: 1, section: 0)) as? SearchPhotosCell else {
            return XCTFail("Should cast the cell")
        }
        assertNoDifference("Japon", cell.searchPhotoDescription.text)
    }

    // --- Tap.
    func test_whenTap_triggerDetailView() {
        // --- setup.
        guard let sut = setupSut() else { XCTFail("Should return an instance of SearchViewController"); return  }
        sut.router = routerSpy
        XCTAssertNotNil(routerSpy)
        sut.loadViewIfNeeded()

		// --- given.
        sut.resultSearchPhotos = .init(displayedPhotos: [
            .init(description: "Paris"),
            .init(description: "Japon")
        ])

        // when tap
        sut.tableView(sut.tableview, didSelectRowAt: IndexPath(row: 0, section: 0))

		// detail router is invoked with id
        XCTAssertTrue(routerSpy.invokedRootToSearchPhotosDetails)
//        assertNoDifference(routerSpy.resultID, "0")
    }

    // ==================
    // MARK: - Test doubles
    // ==================
    class RouterSpy: SearchPhotosRoutingLogic {
        var navigationController: UINavigationController?
        var invokedRootToSearchPhotosDetails = false
        var resultID: String!

        func rootToSearchPhotosDetails(withID id: String) {
			invokedRootToSearchPhotosDetails = true
			resultID = id
        }
    }

    // Interactor
    class SearchPhotosBusinessLogicSpy: SearchPhotosBusinessLogic {
        var invokedSearchPhotos = false

        func fetchPhotos(withRequest: SearchPhotos.FetchPhotos.Request) {
            invokedSearchPhotos = true
        }
    }

    // TableView
    class TableViewSpy: UITableView {
        var invokedReloadDataInvoked = false
        override func reloadData() {
            invokedReloadDataInvoked = true
        }
    }


    // MARK: - Support
    func setupSut() -> SearchPhotosViewController? {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        guard
            let sut = storyboard.instantiateViewController(withIdentifier: SearchPhotosViewController.identifier) as? SearchPhotosViewController
        else {
            XCTFail("should cast the UIViewController")
            return nil
        }
        return sut
    }
}
