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

    var currentManagerVCSpy: CurrentManagerVCSpy!
    var firstVCSpy: SourceVCSpy!

    override func setUp() {
        super.setUp()
        sut = SearchPhotosRouterImpl()

        firstVCSpy = SourceVCSpy()
        currentManagerVCSpy = CurrentManagerVCSpy(rootViewController: firstVCSpy)

        sut.source = currentManagerVCSpy
    }
    override func tearDown() {
        sut = nil
        currentManagerVCSpy = nil
        firstVCSpy = nil
        super.tearDown()
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
