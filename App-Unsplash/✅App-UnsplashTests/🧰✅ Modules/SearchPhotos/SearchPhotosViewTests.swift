//
// SearchPhotosViewTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest
import CustomDump

class SearchPhotosViewTests: XCTestCase {
    var sut: SearchPhotosViewImpl!
    var interactorSpy: InteractorSpy!

    override func setUp() {
        super.setUp()
        sut = SearchPhotosViewImpl()
        interactorSpy = InteractorSpy()

        sut.interactor = interactorSpy
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_givenView_init_expect_isNotNil() {
        XCTAssertNotNil(sut)
    }
    func test_givenView_init_expect_routerIsNotNil() {
//        sut.
    }

    func test_givenView_searchPhotosWithRequest_expect_interactorInvoked() {
        sut.searchPhotos(with: "")

        XCTAssertTrue(interactorSpy.searchPhotosInvoked)
    }


    // --- make URL.
    func test_givenStringUrlOfPhoto_when_makePictureWithString_expect_emptyDataofUrl() {
         let expectedPicture: Data? = UIImage(named: "noPicture")?.pngData()

        // --- when.
        let actualPicture = sut.makePicture(with: "")

        // --- then.
        XCTAssertEqual(expectedPicture, actualPicture)
    }
    func test_givenStringUrlOfPhoto_when_makePictureWithString_expect_wrongDataofUrl() {
        let expectedPicture = UIImage(named: "noPicture")?.pngData()

        // --- when.
        let actualPicture = sut.makePicture(with: "0123")

        // --- then.
        XCTAssertEqual(expectedPicture, actualPicture)
    }
    func test_givenStringUrlOfPhoto_when_makePictureWithString_expect_goodDataofUrl() {
        // --- given.
        let urlString = "https://images.unsplash.com/photo-1526121846098-84e5d2e3437b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=Mnw1NDcwN3wwfDF8c2VhcmNofDF8fGNhcnJ8ZW58MHx8fHwxNjU2OTQxNDE4&ixlib=rb-1.2.1&q=80&w=400"
        let url = URL(string: urlString)!
        let expectedPicture = try? Data(contentsOf: url)

        // --- when.
        let actualPicture = sut.makePicture(with: urlString)

        // --- then.
        assertNoDifference(expectedPicture, actualPicture)
    }

    // ================
    // MARK: - test double
    // ==================
    class InteractorSpy: SearchPhotosInteractor {
        var searchPhotosInvoked = false

        func searchPhotos(with request: String) {
			searchPhotosInvoked = true
        }
    }
}
