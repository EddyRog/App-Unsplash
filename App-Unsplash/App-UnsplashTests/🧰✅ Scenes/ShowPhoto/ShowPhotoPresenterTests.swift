//
// ShowPhotoPresenterTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest

class ShowPhotoPresenterTests: XCTestCase {
    var sut: ShowPhotoPresenterImpl!
    var viewSpy: ViewSpy!
    override func setUp() {
        super.setUp()
        sut = ShowPhotoPresenterImpl()
        viewSpy = ViewSpy()
        sut.view = viewSpy
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init_expect_notnil() {
        XCTAssertNotNil(sut)
    }
    func test_present_shouldFormattoViewModel() {
        let responseStubbed = ShowPhoto.GetPhoto.Response(photo: Photo(description: "description"))

        // --- when.
        sut.presentPhoto(with: responseStubbed)

        let viewmodelExpected = viewSpy.resultViewModel.displayedPhoto
        // --- then.
        XCTAssertEqual("description", viewmodelExpected.description)
    }
    func test_presentPhoto_shouldAskToViewControllerToDisplayPhoto() {

        sut.presentPhoto(with: .init(photo: Photo()))

        XCTAssertTrue(viewSpy.displayPhotoInvoked, "should ask to viewController to display it ")
    }

    // ==================
    // MARK: - test doubles
    // ==================
    class ViewSpy: ShowPhotoView {
        var resultViewModel: ShowPhoto.GetPhoto.ViewModel!
        var displayPhotoInvoked = false

        func displayPhoto(with viewmodel: ShowPhoto.GetPhoto.ViewModel) {
            resultViewModel = viewmodel
            displayPhotoInvoked = true
        }
    }
}
