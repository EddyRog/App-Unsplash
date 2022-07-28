//
// ShowPhotoInteractorTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest
import CustomDump

class ShowPhotoInteractorTests: XCTestCase {
    var sut: ShowPhotoInteractor!
    var presenterSpy: ShowPhotoPresentationLogicSpy!
    var showPhotosWorkerSpy: ShowPhotosWorkerSpy!
    var showServiceMemorySpy: ShowServiceMemorySpy!

    override func setUp() {
        super.setUp()
        sut = ShowPhotoInteractor()
        presenterSpy = ShowPhotoPresentationLogicSpy()
        showPhotosWorkerSpy = ShowPhotosWorkerSpy(service: .noService) // no service
        showServiceMemorySpy = ShowServiceMemorySpy()

        // --- setup.
        sut.presenter = presenterSpy
        showPhotosWorkerSpy.service = showServiceMemorySpy // Worker + customService to test
        sut.worker = showPhotosWorkerSpy
    }
    override func tearDown() {
        sut = nil
        presenterSpy = nil
        super.tearDown()
    }

    func test_init__expect_interactorIsNotNil() {
        XCTAssertNotNil(sut)
    }
    func test_init__expect_interactorKnowsPresenter() {
        sut.presenter?.presentPhoto(response: ShowPhoto.FetchBook.Response(photo: Photo()))
        XCTAssertNotNil(sut.presenter)
        XCTAssertTrue(presenterSpy.presentPhotoInvoked)
    }
    func test_init__expect_interactorKnowsWorker() {
        XCTAssertNotNil(sut.worker)
    }

    func test_fetchPhotoWithID__expect_workerInvokedWithID() {
		// FIXME: ⚠️ Fix statement ⚠️
        sut.fetchPhotoWithID()
//        XCTAssertTrue(showPhotosWorkerSpy.resultPhotoID)
    }
    func test_fetchPhoto_withID__expect_PresentResponse() {
        // --- given.
        sut.dataPhotoID = Seed.Json.idPhoto
        let resultPhotoStubbed = Photo(description: "Ford in to the wild")
        showServiceMemorySpy.completionStubbed = resultPhotoStubbed


        // --- when.
        sut.fetchPhotoWithID()

        // --- then.
        XCTAssertNotNil(sut.worker)
        XCTAssertNotNil(sut.worker?.service)
        XCTAssertTrue(showServiceMemorySpy.fetchPhotoWithIDInvoked)

        XCTAssertNotNil(presenterSpy.resultResponse)
        assertNoDifference(resultPhotoStubbed.description, presenterSpy.resultResponse?.photo.description)
    }

    // ==================
    // MARK: - Test doubles
    // ==================
    class ShowPhotoPresentationLogicSpy: ShowPhotoPresentationLogic {
        var presentPhotoInvoked = false
        var resultResponse: ShowPhoto.FetchBook.Response?

        func presentPhoto(response: ShowPhoto.FetchBook.Response) {
            presentPhotoInvoked = true
            resultResponse = response
        }
    }
    class ShowPhotosWorkerSpy: PhotosWorker {
        var showPhotosWorkerSpy: String?
        var resultPhotoID: String?

        override func fetchPhoto(withID id: String, completionHandler fetchPhotoCompletion: @escaping (Photo) -> Void) {
			resultPhotoID = id
            service?.fetchPhoto(withID: resultPhotoID ?? "", completionHandler: { photo in
				// send back to corker
                fetchPhotoCompletion(photo)
            })
        }
    }
    class ShowServiceMemorySpy: PhotosServiceProtocol {
        var fetchPhotoWithIDInvoked = false
        var completionStubbed: Photo = Photo(description: nil) // need default value for completion compliance

        func fetchPhoto(withID: String, completionHandler: @escaping (Photo) -> Void) {
            fetchPhotoWithIDInvoked = true
            completionHandler(completionStubbed)
        }

        func fetchPhotos(withRequest: String, completionHandler: @escaping ([Photo]) -> Void) { }
    }
}
