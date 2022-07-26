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
        sut.registerTableViewCells()

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
    // TODO: ❎ impl tap on make ❎

    // ==================
    // MARK: - Test doubles
    // ==================
    class RouterSpy: SearchPhotosRoutingLogic {
        var invokedRootToSearchPhotosDetails = false

        func rootToSearchPhotosDetails(withID: String) {
			invokedRootToSearchPhotosDetails = true
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






    /*
    // --- make PictureURL.
    func test_givenStringUrlOfPhoto_when_makePictureWithString_expect_emptyDataofUrl() {
         let expectedPicture: Data? = UIImage(named: "noPicture")?.pngData()

        // --- when.
        let actualPicture = sut.makePicture(with: "")

        // --- then.
        XCTAssertEqual(expectedPicture, actualPicture)
    }
    func test_givenStringUrlOfPhoto_when_makePictureWithString_expect_wrongDataofUrl() {
        let expectedPicture = UIImage(named: "noPicture")?.pngData()

        // --- when.
        let actualPicture = sut.makePicture(with: "0123")

        // --- then.
        XCTAssertEqual(expectedPicture, actualPicture)
    }
    func test_givenStringUrlOfPhoto_when_makePictureWithString_expect_goodDataofUrl() {
        // --- given.
        let urlString = "https://images.unsplash.com/photo-1526121846098-84e5d2e3437b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=Mnw1NDcwN3wwfDF8c2VhcmNofDF8fGNhcnJ8ZW58MHx8fHwxNjU2OTQxNDE4&ixlib=rb-1.2.1&q=80&w=400"
        let url = URL(string: urlString)!
        let expectedPicture = try? Data(contentsOf: url)

        // --- when.
        let actualPicture = sut.makePicture(with: urlString)

        // --- then.
        assertNoDifference(expectedPicture, actualPicture)
    }

    // FIXME: ⚠️ need to check ⚠️
    // --- Details View.
    func test_givenTableView_tapOnRow_expect_showPhotoIndexPath() {
		// --- given.
        let tableviewLocal: UITableView = UITableView() // tableView programmat...
        sut.tableview = tableviewLocal // set it

        sut.tableview.delegate = sut // set the owner of tableViewResponse

        // pass dummy IndexPath
        let dummyIndexPath: IndexPath = IndexPath(item: 1, section: 0)
        sut.tableview.delegate?.tableView?(sut.tableview, didSelectRowAt: dummyIndexPath) // trigger a didSelect at ...

//        XCTAssertTrue(interactorSpy.searchPhotosIndexPathInvoked, "interactor should be invoked")
    }

    // FIXME: ⚠️ need to check ⚠️
    // --- Router Present details view.
    func test_given_View_whenPresenterDidObtainPhotoId_expect_routerInvoked() {
        sut.presenter(didObtainPhotoID: "ID")

//        XCTAssertTrue(routerSpy.showSearchPhotoDetailInvoked, "Should call the router")
//        assertNoDifference("ID", routerSpy.showSearchPhotoDetailResult)
    }
*/
    // ================
    // MARK: - test double
    // ==================
    /*
    class InteractorSpy: SearchPhotosBusinessLogic {

        var searchPhotosInvoked = false
        var searchPhotosIndexPathInvoked = false


        func searchPhotos(with request: String) {
            searchPhotosInvoked = true
        }

        func searchPhotosIndexPath(_ indexpath: IndexPath) {
            searchPhotosIndexPathInvoked = true
        }
    }

    class RouterSpy: SearchPhotosRouterProtocol {

        var navigationController: UINavigationController?
        var showSearchPhotoDetailInvoked = false
        var showSearchPhotoDetailResult: String?


        func showSearchPhotoDetails(with id: String) {
            showSearchPhotoDetailInvoked = true
            showSearchPhotoDetailResult = id
        }
    }
     */
}
