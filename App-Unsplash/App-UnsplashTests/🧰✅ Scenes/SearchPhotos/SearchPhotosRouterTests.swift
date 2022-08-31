//
// SearchPhotosRouterTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest
import CustomDump

class SearchPhotosRouterTests: XCTestCase {

    var sut: SearchPhotosRouter!

    override func setUp() {
        super.setUp()

        let dummyUINavigationController: UINavigationController = UINavigationController()
        sut = SearchPhotosRouter(navigationController: dummyUINavigationController)
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    
    func test_rootToShowPhoto_withID__expect_invokedUINavigationController() {
        // --- given.
        let uiNavigationControllerSPY = UINavigationControllerSPY()
        sut.navigationController = uiNavigationControllerSPY
        sut.rootToShowPhoto(withID: "0")
        XCTAssertTrue(uiNavigationControllerSPY.viewControllerPushed)
    }

    // ==================
    // MARK: - Test doubles
    // ==================
    class UINavigationControllerSPY: UINavigationController {
        var viewControllerPushed: Bool!

        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            viewControllerPushed = true
        }
    }
}
