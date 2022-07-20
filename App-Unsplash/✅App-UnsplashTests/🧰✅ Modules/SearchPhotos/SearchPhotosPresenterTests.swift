//
// PresenterSearchPhotosTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest
import CustomDump

class PresenterSearchPhotosTests: XCTestCase {
    var sut: SearchPhotosPresenterImpl!
    var viewSpy: ViewSpy!
    override func setUp() {
        super.setUp()
        sut = SearchPhotosPresenterImpl()
        viewSpy = ViewSpy()

        sut.view = viewSpy
    }
    override func tearDown() {
        sut = nil
        viewSpy = nil
        super.tearDown()
    }

    func test_givenPresenter_whenInit_expect_notNil() {
        XCTAssertNotNil(sut)
    }

    func test_givenPresenter_whenPresentWithResponse_expect_ViewInvoked() {
		// --- given.
        let responses = [Response]()

		// --- when.
        sut.presentSearchPhotos(with: responses)

        // --- then.
        XCTAssertTrue(viewSpy.displayInvoked, "should be invoked")
    }

    func test_givenPresenter_whenPresentWithResponse_expect_OneViewModel() {
        // --- given.
        let responses = [Response(description: "description0")]

        // --- when.
        sut.presentSearchPhotos(with: responses)

        // --- then.
        XCTAssertEqual(viewSpy.resultOfViewModels, [ViewModel(description: "description0")])
    }
    func test_givenPresenter_whenPresentWithResponse_expect_ManyViewModel() {
        // --- given.
        let responses = [
            Response(description: "description0", urlSmall: "urlSmall"),
            Response(description: "description1"),
        ]
        let expectedViewModels = [
            ViewModel(description: "description0", urlSmall: "urlSmall" ),
            ViewModel(description: "description1")
        ]

        // --- when.
        sut.presentSearchPhotos(with: responses)

        // --- then.
        XCTAssertEqual(expectedViewModels ,viewSpy.resultOfViewModels)
    }

    // --- presenter(DidObtainID).
    func test_givenPresenter_whenPresenterDidObtainPhotoId_expect_ViewInvoked() {
        sut.interactor(didFindIdPhoto: "ID")

        XCTAssertTrue(viewSpy.didObtainIdInvoked, "should call the view")
        assertNoDifference(viewSpy.resultDidObtainId, "ID")
    }

    // ==================
    // MARK: - test doubles
    // ==================
    class ViewSpy: SearchPhotosView {
        var displayInvoked = false
        var resultOfViewModels: [ViewModel]?
        var didObtainIdInvoked = false
        var resultDidObtainId: String?

        func display(with viewModel: [ViewModel]) {
            displayInvoked = true
            resultOfViewModels = viewModel
        }
        func presenter(didObtainPhotoID id: String) {
            didObtainIdInvoked = true
            resultDidObtainId = id
        }
    }
}

