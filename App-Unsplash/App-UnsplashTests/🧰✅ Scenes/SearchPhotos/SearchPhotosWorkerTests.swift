//
// SearchPhotosWorkerTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0


@testable import App_Unsplash
import XCTest
import CustomDump

class SearchPhotosWorkerTests: XCTestCase {
    var sutWorker: SearchPhotosWorker!

    override func setUp() {
        super.setUp()
        sutWorker = SearchPhotosWorker()
    }
    override func tearDown() {
        sutWorker = nil
        super.tearDown()
    }

    func test_init_worker__expect_notNil() {
		XCTAssertNotNil(sutWorker)
    }
    func test_fetchPhoto__expect_serviceInvoked() {
		// --- given.
        let serviceMemory = ServiceMemorySpy()
        serviceMemory.stubResponse = [Photo]()
        sutWorker.service = serviceMemory

		// --- when.
        let expectation = expectation(description: "wait to sut.fetchPhoto(:)")
        sutWorker.fetchPhotos(withRequest: "") { photos in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)

        // --- then.
        XCTAssertTrue(serviceMemory.fetchPhotosInvoked)
    }

    func test_fetchPhoto_withRequest_AndServiceReturnData__expect_workerGetRightResponse() {
        // --- given.
        let serviceMemorySPY = ServiceMemorySpy()
        serviceMemorySPY.stubResponse = [Seed.Photos.nice]
        sutWorker.service = serviceMemorySPY

        // --- when.
        let expectation = expectation(description: "wait to sut.fetchPhoto(:)")
        sutWorker.fetchPhotos(withRequest: "") { photos in
            // --- then.
            self.assertNoDifference("Nice", photos.first?.description)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }

    // TODO: ❎ Test when Service Return a response with error and data + status response ❎
    // TODO: ❎ given worker when service searchPhoto(req:) and ReturnSuccessWithNo Data then return Error ❎
    // TODO: ❎ given worker when service searchPhoto(req:) and ReturnFailure then return Error ❎

    // ==================
    // MARK: - Tests double
    // ==================
    class ServiceMemorySpy: SearchPhotosStoreProtocol {
        var fetchPhotosInvoked = false
        var stubResponse: [Photo]!

        func fetchPhotos(withRequest: String, completionHandler: @escaping ([Photo]) -> Void) {
            fetchPhotosInvoked = true
            completionHandler(stubResponse)
        }
    }
}
