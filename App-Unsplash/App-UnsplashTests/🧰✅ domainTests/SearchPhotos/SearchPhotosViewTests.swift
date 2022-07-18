//
// SearchPhotosViewTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest
import CustomDump

class SearchPhotosViewTests: XCTestCase {
    var sut: SearchPhotosViewImpl!
    var interactorSpy: InteractorSpy!

    override func setUp() {
        super.setUp()
        sut = SearchPhotosViewImpl()
        interactorSpy = InteractorSpy()

        sut.interactor = interactorSpy
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_givenView_init_expect_isNotNil() {
        XCTAssertNotNil(sut)
    }

    func test_givenView_searchPhotosWithRequest_expect_interactorInvoked() {
        sut.searchPhotos(with: "")

        XCTAssertTrue(interactorSpy.searchPhotosInvoked)
    }

    // ==================
    // MARK: - output
    // ==================

    // ================
    // MARK: - test double
    // ==================
    class InteractorSpy: SearchPhotosInteractor {
        var searchPhotosInvoked = false

        func searchPhotos(with request: String) {
			searchPhotosInvoked = true
        }
    }
}
