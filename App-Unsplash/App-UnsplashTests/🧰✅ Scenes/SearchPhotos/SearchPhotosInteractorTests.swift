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

    static let dummyRequest = SearchPhotos.RetrievePhotos.Request.init(query: "_")

    override func setUp() {
        super.setUp()
        searchPhotosPresenterSPY = SearchPhotosPresenterSPY()
        workerPhotosSPY = PhotosWorkerSpy()

        sut = SearchPhotosInteractor(worker: workerPhotosSPY, presenter: searchPhotosPresenterSPY)
    }
    override func tearDown()  {
		sut = nil
        searchPhotosPresenterSPY = nil
        workerPhotosSPY = nil
        super.tearDown()
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
        let expectedResponse: SearchPhotos.RetrievePhotos.Response = .init(photos: [Photo]())

        // --- then.
        sut.retrivePhotos(withRequest: 	SearchPhotosInteractorTests.dummyRequest)

        // --- then.
        assertNoDifference(expectedResponse, searchPhotosPresenterSPY.resultResponse)
    }

    func test_retrievePhotos__expect_onePhoto() {
        // --- given.
        let expectedResponse: SearchPhotos.RetrievePhotos.Response = .init(photos: [
            Photo(photoID: "ID0", description: "Photo0", userName: "UserName0")
        ])
        workerPhotosSPY.makeData = [.init(photoID: "ID0", description: "Photo0", userName: "UserName0")]

        // --- then.
        sut.retrivePhotos(withRequest: SearchPhotosInteractorTests.dummyRequest)

        // --- then.
        assertNoDifference(expectedResponse, searchPhotosPresenterSPY.resultResponse)
    }

    func test_retrievePhotos__expect_manPhoto() {
        // --- given.
        let expectedResponse: SearchPhotos.RetrievePhotos.Response = .init(photos: [
            Photo(photoID: "ID0", description: "Photo0", userName: "User0"),
            Photo(photoID: "ID1", description: "Photo1", userName: "User1")
        ])
        workerPhotosSPY.makeData = [
            .init(photoID: "ID0", description: "Photo0", userName: "User0"),
            .init(photoID: "ID1", description: "Photo1", userName: "User1")
        ]

        // --- then.
        sut.retrivePhotos(withRequest: SearchPhotosInteractorTests.dummyRequest)

        // --- then.
        assertNoDifference(expectedResponse, searchPhotosPresenterSPY.resultResponse)
    }

    // ==================
    // MARK: - Test doubles
    // ==================
    class SearchPhotosPresenterSPY: SearchPhotosPresentable {

        var invokedPresenter: Bool!
        var resultResponse: SearchPhotos.RetrievePhotos.Response!

        func presentFetchedPhotos(with response: SearchPhotos.RetrievePhotos.Response) {
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
