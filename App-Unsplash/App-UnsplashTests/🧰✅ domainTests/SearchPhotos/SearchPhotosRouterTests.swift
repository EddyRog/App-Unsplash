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
    var searchPhotosView: SearchPhotosViewImpl!

    var currentManagerVCSpy: CurrentManagerVCSpy!
    var firstVCSpy: SourceVCSpy!

    override func setUp() {
        super.setUp()
        sut = SearchPhotosRouterImpl()
        searchPhotosView = try? sut.buildWithStoryboard()

        firstVCSpy = SourceVCSpy()
        currentManagerVCSpy = CurrentManagerVCSpy(rootViewController: firstVCSpy)

        sut.source = currentManagerVCSpy
    }
    override func tearDown() {
        sut = nil
        searchPhotosView = nil
        currentManagerVCSpy = nil
        firstVCSpy = nil
        super.tearDown()
    }

    func test_router_init_expect_isNotNil() {
        XCTAssertNotNil(sut)
    }

    // View
    func test_router_build_expect_viewIsNotNil() {
        XCTAssertNotNil(searchPhotosView)
    }

    func test_router_expect_viewKnowTheRouter() {
        XCTAssertNotNil(searchPhotosView.router)
    }

    // check if scene delegate init SearchPhotosView
    func test_router_build_expect_viewInStoryboard_isNotNil() {
        XCTAssertNoThrow(searchPhotosView, "Custom class name in storyboard is wrong /or check in scene delegate")
    }

    func test_router_buildSearchPhotosView_expect_viewInStoryboard_throwsAnError() {
		let wrongIdentifier = "_"
        XCTAssertThrowsError(try sut.buildWithStoryboard(withIdentifier: wrongIdentifier), "Should throws an error")
    }

    // interactor
    func test_router_build_expect_interactorInViewIsNotNil() {
        XCTAssertNotNil(searchPhotosView.interactor)
    }


    // routing to
    func test_givenRouter_whenShowSearchShowDetails_expect_presenterCalled_onSource() {
        sut.showSearchPhotoDetails()

        // mock uinavigationController
        XCTAssertTrue(currentManagerVCSpy.pushViewControllerCalled)
    }
    // ==================
    // MARK: - Test Doubles
    // ==================
    class CurrentManagerVCSpy: UINavigationController {
        var pushViewControllerCalled = false
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            pushViewControllerCalled = true
        }
    }
    class SourceVCSpy: UIViewController {}



}
