//
// ShowPhotoRouterTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest

class ShowPhotoRouterTests: XCTestCase {
    var sut: ShowPhotoRouter!
    override func setUp() {
        super.setUp()
        sut = ShowPhotoRouter(navigationController: UINavigationController())
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init_router__expect_isNotNil() {
        XCTAssertNotNil(sut)
    }
    func test_init_router__expect_navigationControllerIsNotNil() {
        XCTAssertNotNil(sut.navigationController)
    }
	// TODO: ❎ rootingBack if needed ❎
}
