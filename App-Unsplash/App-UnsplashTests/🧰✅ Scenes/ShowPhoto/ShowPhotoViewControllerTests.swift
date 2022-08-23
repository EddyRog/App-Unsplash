////
//// SearchPhotosViewControllerTests.swift
//// App-UnsplashTests
//// Created in 2022
//// Swift 5.0
//
@testable import App_Unsplash
import XCTest
import CustomDump

class ShowPhotosViewControllerTests: XCTestCase {

    var sut: ShowPhotoViewController!
    static let dummyRequest: ShowPhoto.FetchPhoto.Request = .init(query: "0")

    override func setUp() {
        super.setUp()
        sut = ShowPhotoViewController()
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init_ShowPhotoViewController__expect_notNil() {
        XCTAssertNotNil(sut)
    }

    func test_showPhoto_withID__expect_invokedInteractor() {
        // --- given.
        let showPhotoInteractorSPY = ShowPhotoInteractorSPY()
        sut.interactor = showPhotoInteractorSPY

        // --- when.
        sut.showPhoto(withID: ShowPhotosViewControllerTests.dummyRequest)

        // --- then.
        XCTAssertTrue(showPhotoInteractorSPY.invokedInteractor)
    }

    func test_showPhoto_withID__expect_getRightIDPassed() {
        // --- given.
        let showPhotoInteractorSPY = ShowPhotoInteractorSPY()
        sut.interactor = showPhotoInteractorSPY

        // --- when.
        sut.showPhoto(withID: ShowPhotosViewControllerTests.dummyRequest)

        // --- then.
        assertNoDifference("0",showPhotoInteractorSPY.resultRequestPassed.query)
    }

    // ==================
    // MARK: - Test doubles
    // ==================
    class ShowPhotoInteractorSPY: ShowPhotosBusinessLogic {

        var invokedInteractor: Bool!
        var resultRequestPassed: ShowPhoto.FetchPhoto.Request!

        func retrievePhoto(withID request: ShowPhoto.FetchPhoto.Request) {
            invokedInteractor = true
            resultRequestPassed = request

        }



//        func retrivePhotos(withRequest request: ShowPhoto.FetchPhoto.Request) {
//        }
    }
}
