//
// ShowPhotoConfiguratorTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest

class ShowPhotoConfiguratorTests: XCTestCase {
    var sut: ShowPhotoConfigurator!
    var actualShowPhotoViewController = try? ShowPhotoConfigurator().buildWithStoryboard()
    override func setUp() {
        super.setUp()
        sut = ShowPhotoConfigurator()
        actualShowPhotoViewController = try? sut.buildWithStoryboard()
    }
    override func tearDown() {
        sut = nil
        actualShowPhotoViewController = nil
        super.tearDown()
    }

    func test_init__expect_notNil() {
        XCTAssertNotNil(sut)
    }
    func test_buildWithStoryboard__expect_ShowPhotoViewController_isNotNil() {
        // --- then.
        XCTAssertNotNil(actualShowPhotoViewController)
    }
    func test_buildWithStoryboard__expect_ShowPhotoViewController_KnowsTheRouter() {
        // --- given.
        guard let showPhotoViewController = actualShowPhotoViewController else { XCTFail("ShowPhotoViewController should not be optionnal"); return}

        // --- when.
        sut.configureModule(photoID: "", showPhotoViewController)

        // --- then.
        XCTAssertNotNil(showPhotoViewController.router)
        XCTAssertNotNil(showPhotoViewController.interactor)
        XCTAssertNotNil(showPhotoViewController.interactor?.dataPhotoID)
    }
}
