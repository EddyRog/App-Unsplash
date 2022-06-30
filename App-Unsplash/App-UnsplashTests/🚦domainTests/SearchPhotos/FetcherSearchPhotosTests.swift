//
// FetcherSearchPhotosTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0
@testable import App_Unsplash
import XCTest
import CustomDump

class FetcherSearchPhotosTests: XCTestCase {
    var sut: FetcherSearchPhotos!

    /*
    override func setUp() {
        super.setUp()
        sut = FetcherSearchPhotos()
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init_fetcher_expect_notNil() {
        XCTAssertNotNil(sut)
    }

    func test_fetch_withEmptyRequest_expect_ArrayOfEmptyPhotos() {
        // --- given.
        let request = "_"
        var actualPhotos = [Photo]()
        let expectedPhotos = [Photo]()

        // --- when.
        let exp = expectation(description: "expected : wait expectation")
        sut.fetch(with: request) { photos in
            actualPhotos = photos
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.05)

        // --- assert.
        assertNoDifference(expectedPhotos, actualPhotos)
    }

    func test_fetch_withRequestCar_expect_ArrayOfOnePhotoOfCar() {
        // --- given.
        let request = "_"
        var actualPhotos = [Photo]()
        let expectedPhotos = [Photo(description: "car", picture: "car.jpg")]

        // --- when.
        let exp = expectation(description: "expected : wait expectation")
        sut.fetch(with: request) { photos in
            actualPhotos = photos
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.05)

        // --- assert.
        assertNoDifference(expectedPhotos, actualPhotos)
    }
	*/
}

// what is important ?  the acation ( login ,
// what test ? = the actions, 1 class / action
