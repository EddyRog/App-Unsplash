// // ✔︎ 
// PresenterSearchPhotosTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest
import CustomDump

class PresenterSearchPhotosTests: XCTestCase {

    var sut: SearchPhotosPresenter!
    var searchPhotosViewControllerSPY:  SearchPhotosViewControllerSPY!

    override func setUp() {
        super.setUp()
        sut = SearchPhotosPresenter()
        searchPhotosViewControllerSPY =  SearchPhotosViewControllerSPY()
        sut.viewController = searchPhotosViewControllerSPY

    }
    override func tearDown() {
        sut = nil
        searchPhotosViewControllerSPY = nil
        super.tearDown()
    }

    // SearchPhotosPresenter
    func test_init_SearchPhotosPresenter__expect_notNil() {
        XCTAssertNotNil(sut)
    }

    func test_present_response__expect_SearchPhotosViewController_isInvoked() {
        // --- given.
        let response = SearchPhotos.FetchPhotos.Response(photos: [Photo]())

        // --- when.
        sut.presentFetchedPhotos(with: response)

        // --- then.
        XCTAssertTrue(searchPhotosViewControllerSPY.invokedViewController)
    }

    func test_present_response__expect_empViewModel() {
        // --- given.
        let response: SearchPhotos.FetchPhotos.Response = .init(photos: [])

        // --- when.
        sut.presentFetchedPhotos(with: response)

        // --- then.
        assertNoDifference(
            SearchPhotos.FetchPhotos.ViewModel.init(displayedPhotos: []),
            searchPhotosViewControllerSPY.resultViewModel)
    }

    func test_present_response__expect_oneViewModel() {
        // --- given.
        let response: SearchPhotos.FetchPhotos.Response = .init(photos: [.init(photoID: "ID0", description: "Picture0", userName: "User0")])

        // --- when.
        sut.presentFetchedPhotos(with: response)

        // --- then.
        assertNoDifference(
            SearchPhotos.FetchPhotos.ViewModel.init(displayedPhotos: [
                .init(
                    urlsmallImage: "Image0",
                    photoID: "ID0",
                    description: "Picture0"
                )
            ]),
            searchPhotosViewControllerSPY.resultViewModel)
    }
    
    func test_present_response__expect_manViewModel() {
        // --- given.
        let response: SearchPhotos.FetchPhotos.Response = .init(photos: [
            .init(photoID: "ID0", description: "Picture0", userName: "User0"),
            .init(photoID: "ID1", description: "Picture1", userName: "User1")
        ])

        // --- when.
        sut.presentFetchedPhotos(with: response)

        // --- then.
        assertNoDifference(
            SearchPhotos.FetchPhotos.ViewModel.init(displayedPhotos: [
                .init(urlsmallImage: "Image0", photoID: "ID0", description: "Picture0"),
                .init(urlsmallImage: "Image1", photoID: "ID1", description: "Picture1"),
            ]),
            searchPhotosViewControllerSPY.resultViewModel)
    }
    // TODO: ❎ Get id to fecht ❎

    // ==================
    // MARK: - Test doubles
    // ==================
    class SearchPhotosViewControllerSPY: SearchPhotosDisplayLogic {

        var invokedViewController: Bool!
        var resultViewModel: SearchPhotos.FetchPhotos.ViewModel?

        func searchPhotos(withRequest: SearchPhotos.FetchPhotos.Request) {
            //
        }
        func displayedFetchedPhotos(viewModel: SearchPhotos.FetchPhotos.ViewModel) {
            invokedViewController = true
            resultViewModel = viewModel
        }
    }
}
