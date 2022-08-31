//
// ShowPhotoConfiguratorTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest

class ShowPhotoConfiguratorTests: XCTestCase {

    var sut: ShowPhotoConfigurator!

    override func setUp() {
        super.setUp()
        sut = ShowPhotoConfigurator(navController: UINavigationController(), idPhoto: "0")
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init_ShowPhotoConfigurator__expect_notNil() {
        XCTAssertNotNil(sut)
    }

    func test_createModule__expect_ShowPhotosViewController() {
        if let searchPhotosViewController = try? sut.createModule() {
            XCTAssertTrue(searchPhotosViewController.isKind(of: ShowPhotoViewController.self))
        }
    }

    func test_createModule_withWrongIdentifier__expect_throwError() {
        Constant.ShowPhoto.identifierViewController = ""
        sut = ShowPhotoConfigurator(navController: UINavigationController(), idPhoto: "0")
        XCTAssertThrowsError(try sut.createModule(), "should throws an error") { error in
            if let errorStoryboard =  error as? ErrorStoryboard {
                XCTAssertEqual(errorStoryboard, .identifierNil)
            } else {
                XCTFail("must cast the error into ErrorStoryboard")
            }
        }
    }

    func test_createModule_withAllDependences__expect_layersAreConnected() {
        XCTAssertNoThrow(try sut.createModule())
        if let showPhotoViewController = try? sut.createModule() {
            XCTAssertNotNil(showPhotoViewController.interactor)
            XCTAssertNotNil(showPhotoViewController.router?.idPhoto)
            XCTAssertNotNil((showPhotoViewController.interactor as? ShowPhotoInteractor)?.worker)
            XCTAssertNotNil( (showPhotoViewController.interactor as? ShowPhotoInteractor)?.presenter )
            XCTAssertNotNil(((showPhotoViewController.interactor as? ShowPhotoInteractor)?.presenter as? ShowPhotoPresenter)?.viewController)
        }
    }
}
