//
// SearchPhotosConfiguratorTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0
// ✔︎ 
@testable import App_Unsplash
import XCTest
import CustomDump
import AudioToolbox

class SearchPhotosConfiguratorTests: XCTestCase {

    var sut: SearchPhotosConfigurator!

    override func setUp() {
        super.setUp()
        sut = SearchPhotosConfigurator()
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init_SearchPhotosConfigurator__expect_notNil() {
        XCTAssertNotNil(sut)
    }
    func test_createModule__expect_SearchPhotosViewController() {
        if let searchPhotosViewController = try? sut.createModule() {
            XCTAssertTrue(searchPhotosViewController.isKind(of: SearchPhotosViewController.self))
        }
    }
    func test_createModule_withWrongIdentifier__expect_throwError() {
        sut.identifier = "_"
        XCTAssertThrowsError(try sut.createModule(), "should throws an error") { error in
            if let errorStoryboard =  error as? ErrorStoryboard {
                XCTAssertEqual(errorStoryboard, .identifierNil)
            } else {
                XCTFail("must cast the error into ErrorStoryboard")
            }
        }
    }
    func test_createModule_withAllDependances__expect_layersAreConnected() {
        XCTAssertNoThrow(try sut.createModule())
        if let searchPhotosViewController = try? sut.createModule() {
            XCTAssertNotNil(searchPhotosViewController.interactor)
            XCTAssertNotNil(searchPhotosViewController.router)
            XCTAssertNotNil( (searchPhotosViewController.interactor as? SearchPhotosInteractor)?.presenter )
            XCTAssertNotNil( ((searchPhotosViewController.interactor as? SearchPhotosInteractor)?.presenter as? SearchPhotosPresenter)?.viewController )
            // FIXME: ⚠️ Connection worker ⚠️
        }
    }
}


