//
// InteractorSearchPhotosTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest
import CustomDump

class SearchPhotosInteractorTests: XCTestCase {
    var sut: SearchPhotosInteractorImpl!
    var workerSpy: WorkerSpy!
    var presenterSpy = PresenterSpy()

    override func setUp() {
        super.setUp()
        sut = SearchPhotosInteractorImpl()

        presenterSpy = PresenterSpy()
        workerSpy = WorkerSpy()

        sut.worker = workerSpy
        sut.presenter = presenterSpy
    }
    override func tearDown() {
        sut = nil
        workerSpy = nil
        super.tearDown()
    }

    func test_givenInteractor_whenSearchPhotos_then_workerIsCalled() {
        sut.searchPhotos(with: "-")
        XCTAssertTrue(workerSpy.invokedSearchPhotos)
    }

    func test_givenInteractor_whenSearchPhotosAndWorkerReturnResponse_expect_PresenterInvoked() {
        workerSpy.stubResponse = []

        sut.searchPhotos(with: "_")

        XCTAssertTrue(presenterSpy.invokedPresentSearchPhoto)
    }

    func test_givenInteractor_whenSearchPhotosAndWorkerReturnEmptyResponse_expect_PresenterPresentEmptyResponse() {
        // --- given.
        workerSpy.stubResponse = [Response(description: "_")]

		// --- when.
        sut.searchPhotos(with: "-")

        // --- then.
        let actualResponse = presenterSpy.resultResponse
        let expectedResponse = [Response(description : "_")]
        XCTAssertEqual(expectedResponse, actualResponse)
    }

    func test_givenInteractor_whenSearchPhotosAndWorkerReturnOneResponse_expect_PresenterPresentOneResponse() {
        // --- given.
        workerSpy.stubResponse = [Response(description: "Car00")]

        // --- when.
        sut.searchPhotos(with: "-")

        // --- then.
        let actualResponse = presenterSpy.resultResponse
        let expectedResponse = [Response(description : "Car00")]
        XCTAssertEqual(expectedResponse, actualResponse)
    }

    func test_givenInteractor_whenSearchPhotosAndWorkerReturnOneResponse_expect_PresenterPresentManyResponse() {
        // --- given.
        workerSpy.stubResponse = [
            Response(description: "Car00"),
            Response(description: "Car01"),
        ]

        // --- when.
        sut.searchPhotos(with: "-")

        // --- then.
        let actualResponse = presenterSpy.resultResponse
        let expectedResponse = [
            Response(description : "Car00"),
            Response(description : "Car01"),
        ]
        XCTAssertEqual(expectedResponse, actualResponse)
    }


    // ==================
    // MARK: - tests double
    // ==================
    class WorkerSpy: SearchPhotosWorker {
        var invokedSearchPhotos = false
        var stubResponse: [Response]?

        func searchPhotos(with request: String, completion: @escaping ([Response]) -> Void) {
            invokedSearchPhotos = true
            if let stubRes = stubResponse {
                completion(stubRes)
            } else {
                completion([])
            }
        }
    }

    class PresenterSpy: SearchPhotosPresenter {
        var invokedPresentSearchPhoto = false
        var resultResponse: [Response]?

        func presentSearchPhotos(with responses: [Response]) {
            invokedPresentSearchPhoto = true
            resultResponse = responses
        }
    }
}
