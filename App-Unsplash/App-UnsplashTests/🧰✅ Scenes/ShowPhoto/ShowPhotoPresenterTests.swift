//
// ShowPhotoPresenterTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest

class ShowPhotoPresenterTests: XCTestCase {

    var sut: ShowPhotoPresenter!

    override func setUp() {
        super.setUp()
        sut = ShowPhotoPresenter()
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init_ShowPhotoPresenter__expect_notNil() {
        XCTAssertNotNil(sut)
    }

    func test_present_response__expect_ShowPhotoViewController_isInvoked() {
        let showPhotoViewControllerSPY = ShowPhotoViewControllerSPY()
        sut.viewController = showPhotoViewControllerSPY
        let response: ShowPhoto.FetchPhoto.Response = .init(photo: Photo(description: ""))

        sut.presentRetrievePhoto(with: response)

        XCTAssertTrue(showPhotoViewControllerSPY.invokedViewController)
    }

    func test_present_response__expect_viewModel() {
        let showPhotoViewControllerSPY = ShowPhotoViewControllerSPY()
        sut.viewController = showPhotoViewControllerSPY

        let response: ShowPhoto.FetchPhoto.Response = .init(photo: Photo(description: "Description01"))

        sut.presentRetrievePhoto(with: response)

        XCTAssertEqual(showPhotoViewControllerSPY.resultViewModel.displayedPhoto.description, "DESCRIPTION01")
    }

    // ==================
    // MARK: - Test doubles
    // ==================
    class ShowPhotoViewControllerSPY: ShowPhotoDisplayLogic {
        var invokedViewController: Bool!
        var resultViewModel: ShowPhoto.FetchPhoto.ViewModel!

        func displayRetrievedPhoto(with viewModel: ShowPhoto.FetchPhoto.ViewModel) {
            invokedViewController = true
            resultViewModel = viewModel
        }
    }
}


/*
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
    let response: SearchPhotos.FetchPhotos.Response = .init(photos: [.init(description: "Picture0")])

    // --- when.
    sut.presentFetchedPhotos(with: response)

    // --- then.
    assertNoDifference(
        SearchPhotos.FetchPhotos.ViewModel.init(displayedPhotos: [.init(description: "Picture0")]),
        searchPhotosViewControllerSPY.resultViewModel)
}

func test_present_response__expect_manViewModel() {
    // --- given.
    let response: SearchPhotos.FetchPhotos.Response = .init(photos: [
        .init(description: "Picture0"),
        .init(description: "Picture1")
    ])

    // --- when.
    sut.presentFetchedPhotos(with: response)

    // --- then.
    assertNoDifference(
        SearchPhotos.FetchPhotos.ViewModel.init(displayedPhotos: [
            .init(description: "Picture0"),
            .init(description: "Picture1"),
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
*/
