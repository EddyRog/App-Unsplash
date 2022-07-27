//
// SearchPhotosRouterTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest
import CustomDump

class SearchPhotosRouterTests: XCTestCase {

    var sutRouter: SearchPhotosRouter!
    // Spy an UINavigationController to check if the push is trigger
    var currentUINavigationControllerSpy: CurrentUINavigationControllerSpy!

//    var currentManagerVCSpy: CurrentManagerVCSpy!
//    var firstVCSpy: SourceVCSpy!

    override func setUp() {
        super.setUp()
        sutRouter = SearchPhotosRouter()
        currentUINavigationControllerSpy = CurrentUINavigationControllerSpy()
        sutRouter.navigationController = currentUINavigationControllerSpy

        //        firstVCSpy = SourceVCSpy()
//        currentManagerVCSpy = CurrentManagerVCSpy(rootViewController: firstVCSpy)
//        sut.source = currentManagerVCSpy
    }
    override func tearDown() {
        sutRouter = nil
        currentUINavigationControllerSpy = nil
//        currentManagerVCSpy = nil
//        firstVCSpy = nil
        super.tearDown()
    }

    func test_initRouter__expect_notNil() {
        XCTAssertNotNil(sutRouter)
    }
    func test_initRouter__expect_navigationControllerIsNotNil() {
        XCTAssertNotNil(sutRouter.navigationController)
    }

    // routing to
    func test_givenRouter_whenShowSearchShowDetails_expect_presenterCalled_onSource() {
		// --- given.
        sutRouter.rootToSearchPhotosDetails(withID: "")

        // --- then.
        XCTAssertTrue(currentUINavigationControllerSpy.viewControllerPushedCalled)
    }

    /*
    func test_destination_when_showSearchPhotoDetails_expect_destinationIsInvoked() {
        let configurator = ShowPhotoConfigurator()
        guard let viewController = try? configurator.buildWithStoryboard(withIdentifier: "ShowPhotoViewImpl") else {
			XCTFail("should be unwrapped")
            return
        }

        configurator.configureModule(photoID: "", viewController)

        sut.showSearchPhotoDetails(with: "")

        XCTAssertNotNil(sut.destionation)

        XCTAssertNotNil(viewController!.router)
        XCTAssertNotNil(viewController?.router?.navigationController)
        XCTAssertNotNil(viewController?.interactor)
    }
*/


    // ==================
    // MARK: - Test Doubles
    // ==================
    // test double of uinavigationController to spy it
    class CurrentUINavigationControllerSpy: UINavigationController {
        var viewControllerPushedCalled = false

        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            viewControllerPushedCalled = true
        }
    }
}
