//
// InteractorSearchPhotosTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest
import CustomDump

class SearchPhotosInteractorTests: XCTestCase {

    var sut: SearchPhotosInteractor!
    var searchPhotosPresenterSPY: SearchPhotosPresenterSPY!
    var workerPhotosSPY: PhotosWorkerSpy!

    static let dummyRequest = SearchPhotos.FetchPhotos.Request.init(query: "_")

    override func setUp() {
        super.setUp()
		sut = SearchPhotosInteractor()
        searchPhotosPresenterSPY = SearchPhotosPresenterSPY()
        workerPhotosSPY = PhotosWorkerSpy()
        sut.presenter = searchPhotosPresenterSPY
        sut.worker = workerPhotosSPY
    }
    override func tearDown()  {
		sut = nil
        searchPhotosPresenterSPY = nil
        workerPhotosSPY = nil
        super.tearDown()
    }

    func test_init_SearchPhotosInteractor__expect_notNil() {
        XCTAssertNotNil(sut)
    }

    func test_retrievePhotos__expect_invokedPresenterAndInvokedWorker() {
        // --- then.
        sut.retrivePhotos(withRequest: SearchPhotosInteractorTests.dummyRequest)

		// --- then.
        XCTAssertTrue(searchPhotosPresenterSPY.invokedPresenter)
        XCTAssertTrue(workerPhotosSPY.invokedWorker)
    }

    func test_retrievePhotos__expect_empPhotos() {
        // --- given.
        let expectedResponse: SearchPhotos.FetchPhotos.Response = .init(photos: [Photo]())

        // --- then.
        sut.retrivePhotos(withRequest: 	SearchPhotosInteractorTests.dummyRequest)

        // --- then.
        assertNoDifference(expectedResponse, searchPhotosPresenterSPY.resultResponse)
    }

    func test_retrievePhotos__expect_onePhoto() {
        // --- given.
        let expectedResponse: SearchPhotos.FetchPhotos.Response = .init(photos: [
            Photo(description: "Photo0")
        ])
        workerPhotosSPY.makeData = [.init(description: "Photo0")]

        // --- then.
        sut.retrivePhotos(withRequest: SearchPhotosInteractorTests.dummyRequest)

        // --- then.
        assertNoDifference(expectedResponse, searchPhotosPresenterSPY.resultResponse)
    }

    func test_retrievePhotos__expect_manPhoto() {
        // --- given.
        let expectedResponse: SearchPhotos.FetchPhotos.Response = .init(photos: [
            Photo(description: "Photo0"),
            Photo(description: "Photo1")
        ])
        workerPhotosSPY.makeData = [
            .init(description: "Photo0"),
            .init(description: "Photo1")
        ]

        // --- then.
        sut.retrivePhotos(withRequest: SearchPhotosInteractorTests.dummyRequest)

        // --- then.
        assertNoDifference(expectedResponse, searchPhotosPresenterSPY.resultResponse)
    }

    // ==================
    // MARK: - Test doubles
    // ==================
    class SearchPhotosPresenterSPY: SearchPhotosPresentationLogic {

        var invokedPresenter: Bool!
        var resultResponse: SearchPhotos.FetchPhotos.Response!

        func presentFetchedPhotos(with response: SearchPhotos.FetchPhotos.Response) {
            invokedPresenter = true
            resultResponse = response
        }
    }

    class PhotosWorkerSpy: PhotosWorkerLogic {


        var invokedWorker: Bool!
        var makeData: [Photo]! = []

        func retrievePhotos(withRequest request: String, complectionRetrieve completionHandler: @escaping ([Photo]) -> Void) {
            invokedWorker = true
            completionHandler(makeData)
        }

        func retrievePhoto(withID request: String, completionRetrieve: @escaping (Photo?) -> Void) { }
    }
}
