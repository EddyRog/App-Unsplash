//
// SearchPhotosWorkerTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0


@testable import App_Unsplash
import XCTest
import CustomDump

class SearchPhotosWorkerTests: XCTestCase {
    var sut: SearchPhotosWorkerImpl!
    var serviceAPISpy: ServiceAPISpy!
    override func setUp() {
        super.setUp()
        sut = SearchPhotosWorkerImpl()
        serviceAPISpy = ServiceAPISpy()

        sut.serviceAPI = serviceAPISpy
    }
    override func tearDown() {
        sut = nil
    	serviceAPISpy = nil
        super.tearDown()
    }

    func test_init_worker_expect_serviceNotNil() {
        XCTAssertNotNil(sut.serviceAPI)
    }

    func test_givenWorker_whenSearchPhoto_expect_ServiceAPIinvoked() {
        // --- when.
		let expectation = expectation(description: "wait to sut.searchPhotos(with:)")
        sut.searchPhotos(with: "_") { _ in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)

        // --- then.
        XCTAssertTrue(serviceAPISpy.searchPhotosInvoked)
    }

    func test_givenWorker_whenSearchPhotoWithRequest_AndServiceAPIThatReturnResponse_expect_WorkerTheRightResponse() {
		// --- given.
        var actualResponse: [Response]?
        let responseExpected = [Response(description: "car00")]
        serviceAPISpy.responseStubbed = [Response(description: "car00")]


        // --- when.
        let expectation = expectation(description: "wait to sut.searchPhotos(with:)")
        sut.searchPhotos(with: "car") { responses in
            // get the response

            actualResponse = responses
            expectation.fulfill() // validate expectation after setting the response
        }
        wait(for: [expectation], timeout: 0.1)

        // --- then.
        assertNoDifference(responseExpected, actualResponse)

    }

    // TODO: ❎ Test when Service Return a response with error and data + status response ❎
    // TODO: ❎ given worker when service searchPhoto(req:) and ReturnSuccessWithNo Data then return Error ❎
    // TODO: ❎ given worker when service searchPhoto(req:) and ReturnFailure then return Error ❎

    // ==================
    // MARK: - Tests double
    // ==================

    class ServiceAPISpy: SearchPhotosServiceAPI {
        var searchPhotosInvoked = false
        var responseStubbed: [Response]?

        func searchPhotos(with request: String, completion: @escaping ([Response]) -> Void) {
            searchPhotosInvoked = true
            completion(responseStubbed ?? [Response]())
        }
    }
}
