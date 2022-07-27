//
// ShowPhotoPresenterTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest
import CustomDump

class ShowPhotoPresenterTests: XCTestCase {
    var sut: ShowPhotoPresenter!
    var viewControllerSpy: ViewControllerSpy!

    override func setUp() {
        super.setUp()
        sut = ShowPhotoPresenter()
        viewControllerSpy = ViewControllerSpy()

        // --- setup.
        sut.viewController = viewControllerSpy
    }
    override func tearDown() {
        sut = nil
        viewControllerSpy = nil
        super.tearDown()
    }

    func test_init_presenter__expect_isNotNil() {
        XCTAssertNotNil(sut)
    }
    func test_present_withResponse__expect_FormatResponse() {
        XCTAssertNotNil(sut.viewController)
        let responseStubbed: ShowPhoto.FetchBook.Response = ShowPhoto.FetchBook.Response(photo: Seed.Photos.paris)

        sut.presentPhoto(response: responseStubbed)

        XCTAssertTrue(viewControllerSpy.displayPhotoInvoked)
        assertNoDifference(viewControllerSpy.resultPhoto.displayedPhotos.description, responseStubbed.photo.description )
    }


    // ==================
    // MARK: - test doubles
    // ==================
    class ViewControllerSpy: ShowPhotoDisplayLogic {
        var displayPhotoInvoked = false
        var resultPhoto: ShowPhoto.FetchBook.ViewModel!

        func displayPhoto(with viewModel: ShowPhoto.FetchBook.ViewModel) {
            displayPhotoInvoked = true
            resultPhoto = viewModel
        }
    }
}
