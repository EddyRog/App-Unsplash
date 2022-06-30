//
// PresenterSearchPhotosTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest
import CustomDump

class PresenterSearchPhotosTests: XCTestCase {
    var sut: PresenterSearchPhotosImpl!
    var viewSpy: ViewSearchPhotosSpy!

    override func setUp() {
        super.setUp()
        sut = PresenterSearchPhotosImpl()
        viewSpy = ViewSearchPhotosSpy()
        sut.view = viewSpy
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init_presenter_expect_notNil() {
        XCTAssertNotNil(sut)
    }

    func test_Presenter_initView_expect_viewIsNotNil() {
        XCTAssertNotNil(sut.view)
    }

    func test_present_withEmptyResponse_expect_emptyViewModel() {
        // setup
        let viewModelExpected = [ViewModel]()

        // --- given.
        let responses = Response(value: [Photo]())

        // --- when.
        sut.present(with: responses)

        // --- then.
        assertNoDifference(viewModelExpected, viewSpy.resultOfViewModels)
    }

    func test_present_withOneResponse_expect_arrayOfViewModelsWithOneData() {
        // setup
        let viewModelExpected = [
            ViewModel(
                description: "description",
                thumbsUrlImage: "thumbsUrlImage0"
            )
        ]

        // --- given.
        let responses = Response(value: [Photo(description: "description", picture: "thumbsUrlImage0")])

        // --- when.
        sut.present(with: responses)

        // --- then.
        assertNoDifference(viewModelExpected, viewSpy.resultOfViewModels)
    }

    func test_present_withManyResponse_expect_arrayOfViewModelWithManyData() {
        // setup
        let viewModelExpected = [
            ViewModel(
                description: "description0",
                thumbsUrlImage: "thumbsUrlImage0"
            ),
            ViewModel(
                description: "description1",
                thumbsUrlImage: "thumbsUrlImage1"
            )
        ]

        // --- given.
        let responses = Response(value: [
            Photo(description: "description0", picture: "thumbsUrlImage0"),
            Photo(description: "description1", picture: "thumbsUrlImage1"),
        ])

        // --- when.
        sut.present(with: responses)

        // --- then.
        assertNoDifference(viewModelExpected, viewSpy.resultOfViewModels)
    }

    // ==================
    // MARK: - Tests Doubles
    // ==================
    class ViewSearchPhotosSpy: ViewSearchPhotos {
        var resultOfViewModels: [ViewModel]?

        func display(with viewModels: [ViewModel]) {
            resultOfViewModels = viewModels
        }
    }
}
