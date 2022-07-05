//
// SearchPhotosRouterTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest
import CustomDump

class SearchPhotosRouterTests: XCTestCase {
    var sut: SearchPhotosRouterImpl!
    var viewController: SearchPhotosViewImpl!
    var interactor: SearchPhotosInteractor!
    var presenter: SearchPhotosPresenter!

    override func setUp() {
        super.setUp()
        sut = SearchPhotosRouterImpl()
        viewController = sut.build()
        interactor = viewController.interactor
        presenter = interactor.presenter
    }
    override func tearDown() {
        sut = nil
        viewController = nil
        interactor = nil
        super.tearDown()
    }

    // --- router.
    func test_init_rooter_expect_notnil() {
        XCTAssertNotNil(sut)
    }

    // --- viewController.
    func test_build_ViewControllerSearchPhotod_expect_NotNil() {
        let actual = viewController
		XCTAssertNotNil(actual)
    }

    // --- interactor.
    func test_build_interactor_expect_notNil() {
        XCTAssertNotNil(interactor)
    }

    // --- presenter.
    func test_build_presenter_expect_notNil() {
        XCTAssertNotNil(presenter)
    }

    // --- view.
    func test_build_view_expect_notNil() {
        XCTAssertNotNil(presenter.view)
    }

    // --- SB.
    func test_build_view_expect_vc_in_storyboard_notNil() {
        XCTAssertNoThrow(try sut.instantiateViewInStoryboard(), "View from router is nil")
    }

    func test_build_viewController_expect_throwErrorStoryboard() {
        sut.identifierSearchPhotosImpl = "-"
        XCTAssertThrowsError(try sut.instantiateViewInStoryboard(), "Should throws an error")
    }
}
