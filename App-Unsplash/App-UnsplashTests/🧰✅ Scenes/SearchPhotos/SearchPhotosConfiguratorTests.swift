//
// SearchPhotosConfiguratorTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest
import CustomDump

class SearchPhotosConfiguratorTests: XCTestCase {

    var sutPhotosConfigurator: SearchPhotosConfigurator!
    var searchPhotosViewController: SearchPhotosViewController!

    override func setUp() {
        super.setUp()
        sutPhotosConfigurator = SearchPhotosConfigurator()

        searchPhotosViewController = try? sutPhotosConfigurator.buildWithStoryboard()
    }
    override func tearDown() {
        sutPhotosConfigurator = nil
        super.tearDown()
    }

    func test_init_expect_isNotNil() {
        XCTAssertNotNil(sutPhotosConfigurator)
    }

    // View
    func test_buildWithStoryboard_expect_viewControllerIsNotNil() {
        XCTAssertNotNil(searchPhotosViewController)
    }

    func test_buildWithStoryboard_expect_viewKnowTheRouter() {
        sutPhotosConfigurator.configureModule(searchPhotosViewController)

        XCTAssertNotNil(searchPhotosViewController.router)
    }

    // check if scene delegate init SearchPhotosView
    func test_router_build_expect_viewInStoryboard_isNotNil() {
        XCTAssertNoThrow(searchPhotosViewController, "Custom class name in storyboard is wrong /or check in scene delegate")
    }

    func test_buildSearchPhotosView_expect_viewInStoryboard_throwsAnError() {
        let wrongIdentifier = "_"
        XCTAssertThrowsError(try sutPhotosConfigurator.buildWithStoryboard(withIdentifier: wrongIdentifier), "Should throws an error")
    }
}
