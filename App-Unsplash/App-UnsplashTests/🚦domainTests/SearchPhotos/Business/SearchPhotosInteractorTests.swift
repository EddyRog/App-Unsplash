//
// InteractorSearchPhotosTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest
import CustomDump

class SearchPhotosInteractorTests: XCTestCase {
    let isTestActivate = false
    var sut         : SearchPhotosInteractorImpl!
    var fetcherStub : FetcherSearchPhotosStub!

    let STUP_EMPTY_DATA: [Photo] = [Photo]()
    let STUP_ONE_DATA: [Photo] = [Photo(description: "DescriptionCar0", picture: "PictureCar0")]
    let STUP_MANY_DATA: [Photo] = [
        Photo(description: "DescriptionCat0", picture: "PictureCat0"),
        Photo(description: "DescriptionCat1", picture: "PictureCat1"),
    ]

    override func setUp() {
        super.setUp()
        let dummyPresenter = SearchPhotosPresenterImpl()
        sut = SearchPhotosInteractorImpl(presenter: dummyPresenter)
    	fetcherStub = FetcherSearchPhotosStub()
        sut.fetcher = fetcherStub
    }

    override func tearDown() {
        sut = nil
        fetcherStub = nil
        super.tearDown()
    }

    func test_init_Interactor_expect_notNil() {
        XCTAssertNotNil(sut)
    }

    func test_init_Interactor_expect_fetcherIsNotNil() {
        XCTAssertNotNil(sut.fetcher)
    }

    func test_fetchPhotos_emptyRequest_expect_emptyResponse() {
        if isTestActivate { return }
		// setup
        fetcherStub.dataToReturn = STUP_EMPTY_DATA

        // --- given.
        let emptyRequest = ""
        let expectedResponses = Response(value: [])
        var actualResponse: Response?

        let expectation = expectation(description: "wait for exepctation")
        // --- when.
        sut.fetchPhotos(with: emptyRequest) {responses in
			actualResponse = responses
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.2)

        // --- then.
        assertNoDifference(expectedResponses, actualResponse)
    }

    func test_fetchPhotos_goodRequest_expect_ResponseWithOneData() {
		// setup
        fetcherStub.dataToReturn = STUP_ONE_DATA

        // --- given.
        let emptyRequest = "CAR"
        let expectedResponses = Response(value: [
            Photo(description: "DescriptionCar0", picture: "PictureCar0")
        ])
        var actualResponse: Response?


        let expectation = expectation(description: "wait for exepctation")
        // --- when.
        sut.fetchPhotos(with: emptyRequest) {responses in
            actualResponse = responses
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.2)

        // --- then.
        assertNoDifference(expectedResponses, actualResponse)
    }

    func test_fetchPhotos_goodRequest_expect_ResponseWithManyData() {
        // setup
        fetcherStub.dataToReturn = STUP_MANY_DATA

		// --- given.
        let emptyRequest = "CAR"
        let expectedResponses = Response(value: [
            Photo(description: "DescriptionCat0", picture: "PictureCat0"),
            Photo(description: "DescriptionCat1", picture: "PictureCat1")
        ])
        var actualResponse: Response?

        let expectation = expectation(description: "wait for exepctation")
        // --- when.
        sut.fetchPhotos(with: emptyRequest) {responses in
            actualResponse = responses
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.2)

        // --- then.
        assertNoDifference(expectedResponses, actualResponse)
    }


    // ==================
    // MARK: - Test doubles
    // ==================
    class FetcherSearchPhotosStub: SearchPhotosFetcher {
        var dataToReturn: [Photo] = []

        func fetch(with request: String, completion: ([Photo]) -> Void) {
            completion(dataToReturn)
        }
    }
}


