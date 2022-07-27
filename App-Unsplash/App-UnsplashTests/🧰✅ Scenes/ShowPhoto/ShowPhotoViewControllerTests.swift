//
// ShowPhotoViewTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest

class ShowPhotoViewControllerTests: XCTestCase {

    var sut: ShowPhotoViewController!

    override func setUp() {
        super.setUp()
        sut = ShowPhotoViewController()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_setup_ViewController__expect_isNotNil() {
        XCTAssertNotNil(sut)
    }

    func test_viewDidLoad__expect_fetchPhotoWithIDInvoked() {
        // --- given.
        let interactorSpy = ShowPhotoBusinessLogicSpy()
        sut.interactor = interactorSpy

        // --- when.
        sut.viewDidLoad()

        // --- then.
        XCTAssertTrue(interactorSpy.fetchPhotoWithIDInvoked)
    }

    // --- DisplayLogic.
    func test_displayPhoto_withViewModel__expect_OutletSeted() {
        sut.photoDescription = ""
        let viewModel = ShowPhoto.FetchBook.ViewModel(displayedPhotos: .init(description: Seed.Photos.paris.description!))

        sut.displayPhoto(with: viewModel)

        assertNoDifference("Paris", sut.photoDescription)
    }

    // ==================
    // MARK: - test Doubles
    // ==================
    class ShowPhotoBusinessLogicSpy: ShowPhotoBusinessLogic, ShowPhotoDataStore {
        
        var dataPhotoID: String?
        var fetchPhotoWithIDInvoked = false

        func fetchPhotoWithID() {
            fetchPhotoWithIDInvoked = true
        }
    }
}
