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
        let response: ShowPhoto.FetchPhoto.Response = .init(photo: Photo(photoID: "", description: ""))

        sut.presentRetrievePhoto(with: response)

        XCTAssertTrue(showPhotoViewControllerSPY.invokedViewController)
    }

    func test_present_response__expect_viewModel() {
        let showPhotoViewControllerSPY = ShowPhotoViewControllerSPY()
        sut.viewController = showPhotoViewControllerSPY

        let response: ShowPhoto.FetchPhoto.Response = .init(photo: Photo(photoID: "ID0", description: "Description01"))

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
