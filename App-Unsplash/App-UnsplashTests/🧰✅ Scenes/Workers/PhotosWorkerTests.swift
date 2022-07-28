//
// SearchPhotosWorkerTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0


@testable import App_Unsplash
import XCTest
import CustomDump

class PhotosWorkerTests: XCTestCase {
    var sut: PhotosWorker!
    var serviceMemorySpy: ServiceMemorySpy!

    override func setUp() {
        super.setUp()
        sut = PhotosWorker(service: .api)
        serviceMemorySpy = ServiceMemorySpy()

        sut.service = serviceMemorySpy
    }
    override func tearDown() {
        sut = nil
        serviceMemorySpy = nil
        super.tearDown()
    }

    func test_init_worker__expect_notNil() {
		XCTAssertNotNil(sut)
    }
    func test_fetchPhotoReques__expect_serviceInvoked() {
		// --- given.
        serviceMemorySpy.fetchPhotoRequestResponseStubbed = [Photo]()

		// --- when.
        let expectation = expectation(description: "wait to sut.fetchPhoto(:)")
        sut.fetchPhotos(withRequest: "") { photos in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)

        // --- then.
        XCTAssertTrue(serviceMemorySpy.fetchPhotosRequestInvoked)
    }

    func test_fetchPhoto_withRequest_AndServiceReturnData__expect_workerGetRightResponse() {
        // --- given.
        serviceMemorySpy.fetchPhotoRequestResponseStubbed = [Seed.Photos.nice]

        // --- when.
        let expectation = expectation(description: "wait to sut.fetchPhoto(:)")
        sut.fetchPhotos(withRequest: "") { photos in
            // --- then.
            self.assertNoDifference("Nice", photos.first?.description)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func test_fetchPhoto_withID_AndServiceReturnData__expect_workerGetResponse() {
        // --- given.
        let photoID = Seed.Json.idPhoto
        serviceMemorySpy.fetchPhotoWithIDResponseStubbed = Seed.Photos.nice

        // --- when.
        let exp = expectation(description: "expected : wait to fetchPhoto(withID id:, completionHandler")
        sut.fetchPhoto(withID: photoID) { photo in
            self.assertNoDifference("Nice", photo.description)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.05)
        XCTAssertTrue(serviceMemorySpy.fetchPhotoWithIDInvoked)
    }

    // TODO: ❎ Test when Service Return a response with error and data + status response ❎
    // TODO: ❎ given worker when service searchPhoto(req:) and ReturnSuccessWithNo Data then return Error ❎
    // TODO: ❎ given worker when service searchPhoto(req:) and ReturnFailure then return Error ❎

    // ==================
    // MARK: - Tests double
    // ==================
    class ServiceMemorySpy: PhotosServiceProtocol {
        var fetchPhotosRequestInvoked = false
        var fetchPhotoRequestResponseStubbed: [Photo]!

        var fetchPhotoWithIDResponseStubbed: Photo!
        var fetchPhotoWithIDInvoked = true

        func fetchPhotos(withRequest: String, completionHandler: @escaping ([Photo]) -> Void) {
            fetchPhotosRequestInvoked = true
            completionHandler(fetchPhotoRequestResponseStubbed)
        }

        func fetchPhoto(withID: String, completionHandler: @escaping (Photo) -> Void) {
            fetchPhotoWithIDInvoked = true
            completionHandler(fetchPhotoWithIDResponseStubbed)
        }
    }
}
