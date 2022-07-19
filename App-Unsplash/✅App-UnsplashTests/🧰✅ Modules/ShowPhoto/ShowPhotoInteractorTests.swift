//
// ShowPhotoInteractorTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest

class ShowPhotoInteractorTests: XCTestCase {
    var sut: ShowPhotoInteractorImpl!
    override func setUp() {
        super.setUp()
        sut = ShowPhotoInteractorImpl()
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init_expect_notnil() {
        XCTAssertNotNil(sut)
    }
    func test_getPhoto_withId_expect_presenterInvoked() {
		// --- given.
        let presenterSpy = PresenterSpy()
        sut.presenter = presenterSpy

		// --- when.
        sut.getPhoto(width: "")

        XCTAssertTrue(presenterSpy.getPhotoInvoked)
    }

    // ==================
    // MARK: - Test Doubles
    // ==================
    class PresenterSpy: ShowPhotoPresenter {

        var getPhotoInvoked = false
        
        func presentPhoto(with response: ShowPhoto.GetPhoto.Response) {
            getPhotoInvoked = true
        }
    }
}
