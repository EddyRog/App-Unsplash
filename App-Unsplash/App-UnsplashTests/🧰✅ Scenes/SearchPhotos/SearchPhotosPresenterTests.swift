// // ✔︎ 
// PresenterSearchPhotosTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest
import CustomDump

class PresenterSearchPhotosTests: XCTestCase {
    var sutPresenter: SearchPhotosPresenter!
    var viewSpy: ViewSpy!

    override func setUp() {
        super.setUp()
        sutPresenter = SearchPhotosPresenter()
        viewSpy = ViewSpy()
        sutPresenter.viewController = viewSpy
    }
    override func tearDown() {
        sutPresenter = nil
        viewSpy = nil
        super.tearDown()
    }

    func test_init__expect_presenterNotNil() {
        XCTAssertNotNil(sutPresenter)
    }

    // invoked // Presenter -> ViewController
    func test_presentFetchedPhotos_withResponse__expect_viewInvoked() {
        // --- given.
        let response = SearchPhotos.FetchPhotos.Response(photos: [Photo]())

        // --- when.
        sutPresenter.presentFetchedPhotos(with: response)

        // --- then.
        XCTAssertTrue(viewSpy.displayedFetchedPhotos)
	}

    func test_presentFetchedPhotos__expect_displayOneResponse() {
        let response = SearchPhotos.FetchPhotos.Response(photos: [Seed.Photos.paris])

        sutPresenter.presentFetchedPhotos(with: response)

        assertNoDifference("Paris", viewSpy.viewModel.displayedPhotos.first?.description)
    }

    // --- presenter(DidObtainID).
//    func test_givenPresenter_whenPresenterDidObtainPhotoId_expect_ViewInvoked() {
//        // --- when.
//        sut.interactor(didFindIdPhoto: "ID")
//
//        XCTAssertTrue(searchPhotoViewControllerSpy.didObtainIdInvoked, "should call the view")
//        assertNoDifference(searchPhotoViewControllerSpy.resultDidObtainId, "ID")
//    }

    // ==================
    // MARK: - test doubles
    // ==================
    class ViewSpy: SearchPhotosDisplayLogic {
        var displayedFetchedPhotos = false
        var viewModel: SearchPhotos.FetchPhotos.ViewModel!

        func searchPhotos(withRequest: SearchPhotos.FetchPhotos.Request) { }
        func displayedFetchedPhotos(viewModel: SearchPhotos.FetchPhotos.ViewModel) {

			displayedFetchedPhotos = true
            self.viewModel = viewModel
        }

        //        func presenter(didObtainPhotoID id: String) {
        //            didObtainIdInvoked = true
        //            resultDidObtainId = id
        //        }
    }
}
