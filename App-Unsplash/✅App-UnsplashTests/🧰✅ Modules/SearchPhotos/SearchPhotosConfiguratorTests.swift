//
// SearchPhotosConfiguratorTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest
import CustomDump

class SearchPhotosConfiguratorTests: XCTestCase {

    var sut: SearchPhotosConfiguratorImpl!
    var searchPhotosView: SearchPhotosViewImpl!

    override func setUp() {
        super.setUp()
        sut = SearchPhotosConfiguratorImpl()
        searchPhotosView = try? sut.buildWithStoryboard()
        sut.configureModule(searchPhotosView)
    }
    override func tearDown() {
        sut = nil
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
}
