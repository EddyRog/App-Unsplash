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
        searchPhotosViewControllerSPY =  SearchPhotosViewControllerSPY()
        sut = SearchPhotosPresenter(viewController: searchPhotosViewControllerSPY)
    }
    override func tearDown() {
        sut = nil
        searchPhotosViewControllerSPY = nil

        super.tearDown()
    }


    func test_present_response__expect_SearchPhotosViewController_isInvoked() {
        // --- given.
        let response = SearchPhotos.RetrievePhotos.Response(photos: [Photo]())

        // --- when.
        sut.presentFetchedPhotos(with: response)

        // --- then.
        XCTAssertTrue(searchPhotosViewControllerSPY.invokedViewController)
    }

    func test_present_response__expect_empViewModel() {
        // --- given.
        let response: SearchPhotos.RetrievePhotos.Response = .init(photos: [])

        // --- when.
        sut.presentFetchedPhotos(with: response)

        // --- then.
        assertNoDifference(
            SearchPhotos.RetrievePhotos.ViewModel.init(displayedPhotos: []),
            searchPhotosViewControllerSPY.resultViewModel)
    }

    func test_present_response__expect_oneViewModel() {
        // --- given.
        let response: SearchPhotos.RetrievePhotos.Response = .init(photos: [.init(photoID: "ID0", description: "Picture0", userName: "User0")])

        // --- when.
        sut.presentFetchedPhotos(with: response)

        // --- then.
        assertNoDifference(
            SearchPhotos.RetrievePhotos.ViewModel.init(displayedPhotos: [
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
        let response: SearchPhotos.RetrievePhotos.Response = .init(photos: [
            .init(photoID: "ID0", description: "Picture0", userName: "User0"),
            .init(photoID: "ID1", description: "Picture1", userName: "User1")
        ])

        // --- when.
        sut.presentFetchedPhotos(with: response)

        // --- then.
        assertNoDifference(
            SearchPhotos.RetrievePhotos.ViewModel.init(displayedPhotos: [
                .init(urlsmallImage: "Image0", photoID: "ID0", description: "Picture0"),
                .init(urlsmallImage: "Image1", photoID: "ID1", description: "Picture1"),
            ]),
            searchPhotosViewControllerSPY.resultViewModel)
    }
    // TODO: ❎ Get id to fetch ❎

    // ==================
    // MARK: - Test doubles
    // ==================
    class SearchPhotosViewControllerSPY: SearchPhotosViewable {

        var invokedViewController: Bool!
        var resultViewModel: SearchPhotos.RetrievePhotos.ViewModel?

        func searchPhotos(withRequest: SearchPhotos.RetrievePhotos.Request) {
            //
        }
        func displayedFetchedPhotos(viewModel: SearchPhotos.RetrievePhotos.ViewModel) {
            invokedViewController = true
            resultViewModel = viewModel
        }
    }
}
