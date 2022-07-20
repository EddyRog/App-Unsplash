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

    // --- searchPhotos.
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

    // --- DataStore.
    func test_givenInteractor_whenSearchPhotos__andWorkerReturnEmptyResponse_expect_dataStoreIsEmpty() {
        // --- given.
        workerSpy.stubResponse = [Response]()
        // --- when.
        sut.searchPhotos(with: "request")

        // --- then.
        assertNoDifference([], sut.dataStorePhotos)
    }
    func test_givenInteractor_whenSearchPhotos__andWorkerReturnManyResponse_expect_dataStoreResponses() {
        // --- given.
        let expectedResponses: [Response] = [
            Response(description: "description0"),
            Response(description: "description1"),
        ]
        workerSpy.stubResponse = expectedResponses
        // --- when.
        sut.searchPhotos(with: "request")

        // --- then.
        assertNoDifference(expectedResponses, sut.dataStorePhotos)
    }

	// --- searchPhotosIndexPath.
    func test_givenDataStoreEmpty_whensearchPhotosIndexPath_expect_presenterInteractorDidFindInvoked() {
        // --- given.
        sut.dataStorePhotos = []
        let expecterResponse = ""

        // --- when.
        sut.searchPhotosIndexPath(IndexPath(item: 0, section: 0))

        // --- .
        XCTAssertTrue(presenterSpy.interactorDidFindInvoked, "presenter should be called")
        assertNoDifference(expecterResponse, presenterSpy.resultResponseID)
    }
    func test_givenDataStoreEmpty_whensearchPhotosIndexPath_expect_presenterInteractorDidFindInvokedWithId() {
        // --- given.
        sut.dataStorePhotos = [Response(description: "description", urlSmall: "urlSmall", id: "id")]
        let expecterResponse = "id"

        // --- when.
        sut.searchPhotosIndexPath(IndexPath(item: 0, section: 0))

        // --- .
        assertNoDifference(expecterResponse, presenterSpy.resultResponseID)
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
        var interactorDidFindInvoked = false
        var resultResponseID: String?

        func presentSearchPhotos(with responses: [Response]) {
            invokedPresentSearchPhoto = true
            resultResponse = responses
        }
        func interactor(didFindIdPhoto id: String) {
            interactorDidFindInvoked = true
            resultResponseID = id
        }
    }
}
