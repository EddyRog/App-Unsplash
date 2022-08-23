////
//// SearchPhotosViewControllerTests.swift
//// App-UnsplashTests
//// Created in 2022
//// Swift 5.0
//
@testable import App_Unsplash
import XCTest
import CustomDump

class SearchPhotosViewControllerTests: XCTestCase {

    var sut: SearchPhotosViewController!

    override func setUp() {
        super.setUp()
        sut = SearchPhotosViewController()
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init_SearchPhotosViewController__expect_notNil() {
        XCTAssertNotNil(sut)
    }
	// VC -> IN
     func test_searchPhotos_withRequest__expect_invokedInteractor() {
        // --- given .
        let searchPhotosInteractorSPY = SearchPhotosInteractorSPY()
        sut.interactor = searchPhotosInteractorSPY
        let request: SearchPhotos.FetchPhotos.Request = .init(query: "Car")

        // --- when.
        sut.searchPhotos(withRequest: request)

        // --- then.
        XCTAssertTrue(searchPhotosInteractorSPY.invokedInteractor)
    }

    func test_searchPhotos_withRequest__expect_rightRequestPassed() {
        // --- given .
        let searchPhotosInteractorSPY = SearchPhotosInteractorSPY()
        sut.interactor = searchPhotosInteractorSPY
        let request: SearchPhotos.FetchPhotos.Request = .init(query: "Car")

        // --- when.
        sut.searchPhotos(withRequest: request)

        // --- then.
        XCTAssertEqual("Car",searchPhotosInteractorSPY.resultRequestPassed)
    }

    // ==================
    // MARK: - Test doubles
    // ==================
    class SearchPhotosInteractorSPY: SearchPhotosBusinessLogic {

        var invokedInteractor: Bool!
        var resultRequestPassed: String!

        func retrivePhotos(withRequest request: SearchPhotos.FetchPhotos.Request) {
			invokedInteractor = true
            resultRequestPassed = request.query
        }
    }
}
