//
// InteractorSearchPhotosTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest
import CustomDump

class SearchPhotosInteractorTests: XCTestCase {
    var sutInteractor: SearchPhotosInteractor!
    var workerSpy: WorkerSpy!
    var presenterSpy: PresenterSpy!
    var fakeService: SearchPhotoServiceStoreFake!

    private let request0 = SearchPhotos.FetchPhotos.Request(query: "")

    override func setUp() {
        super.setUp()

        sutInteractor = SearchPhotosInteractor()
        workerSpy = WorkerSpy(service: .noService)
        fakeService = SearchPhotoServiceStoreFake()
        presenterSpy = PresenterSpy()

        workerSpy.service = fakeService
        // --- stup.
        sutInteractor.worker = workerSpy
        sutInteractor.presenter = presenterSpy
    }

    override func tearDown() {
        sutInteractor = nil
        workerSpy = nil
        presenterSpy = nil
        fakeService = nil
        super.tearDown()
    }

    func test_init_interactor__expect_notNil() {
        XCTAssertNotNil(sutInteractor)
    }
    func test_init_interactor__expect_workerNotNil() {
        XCTAssertNotNil(sutInteractor.worker)
    }
    func test_init_interactor__expect_presenterNotNil() {
        XCTAssertNotNil(sutInteractor.presenter)
    }

    func test_fetchPhotos_withRequest__expect_workerInvoked() {
        sutInteractor.fetchPhotos(withRequest: request0)

        XCTAssertTrue(workerSpy.fetchPhotosInvoked)
    }
    func test_fetchPhotos_withRequest__expect_presenterInvoked() {
        sutInteractor.fetchPhotos(withRequest: request0)

        let exp = expectation(description: "expected : wait worker.searchPhoto(...) to return")
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.1)
        XCTAssertTrue(presenterSpy.presentFetchedPhotosInvoked)
    }

    func test_fetchPhotos_withRequest__expect_PresentResponse() {
        // --- given.
        let workerSpy = WorkerSpy(service: .noService)
        let serviceFake = SearchPhotoServiceStoreFake()
        let presenterSpy = PresenterSpy()

        serviceFake.completionStubbed = [
            Photo(description: "Canada"),
            Photo(description: "Paris"),
        ]
        workerSpy.service = serviceFake
        sutInteractor.worker = workerSpy
        sutInteractor.presenter = presenterSpy

        // --- when.
        self.sutInteractor.fetchPhotos(withRequest: self.request0)

        // --- then.
        // used to trigger the response cause async is used inside of the worker
        let exp = expectation(description: "expected : wait worker.searchPhoto(...) to return")
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
        	self.assertNoDifference("Canada", presenterSpy.resultResponse.photos.first?.description)
        	self.assertNoDifference("Paris", presenterSpy.resultResponse.photos.last?.description)

        	XCTAssertTrue(workerSpy.fetchPhotosInvoked)
        	XCTAssertTrue(presenterSpy.presentFetchedPhotosInvoked)
        exp.fulfill()
        }
        waitForExpectations(timeout: 0.1)
    }

    // ==================
    // MARK: - test doubles
    // ==================
    class WorkerSpy: SearchPhotosWorker {
        var fetchPhotosInvoked = false

        override func fetchPhotos(withRequest request: String, completionHandler: @escaping ([Photo]) -> Void) {
            fetchPhotosInvoked = true

            service?.fetchPhotos(withRequest: "", completionHandler: { photos in
				// Handle the result..
                // Update UI (worker side) Here and let the services to be testable easily
                DispatchQueue.main.async {
					// send back to the worker
                    completionHandler(photos)
                }
            })
        }
    }
    class SearchPhotoServiceStoreFake: SearchPhotosStoreProtocol {

        var completionStubbed: [Photo] = []

        func fetchPhotos(withRequest: String, completionHandler: @escaping ([Photo]) -> Void) {
            // get data  from external ...
            completionHandler(completionStubbed)
            // send back the result
        }
    }
    class PresenterSpy: SearchPhotosPresentationLogic {
        var presentFetchedPhotosInvoked = false
        var resultResponse: SearchPhotos.FetchPhotos.Response!
        func presentFetchedPhotos(with response: SearchPhotos.FetchPhotos.Response) {
            presentFetchedPhotosInvoked = true
            resultResponse = response
        }
    }
}
