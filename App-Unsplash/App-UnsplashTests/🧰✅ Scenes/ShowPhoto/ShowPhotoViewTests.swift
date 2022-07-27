//
// ShowPhotoViewTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest

//class ShowPhotoViewTests: XCTestCase {
//    var sut: ShowPhotoViewImpl!
//    var window: UIWindow!
//
//    override func setUp() {
//        super.setUp()
//        sut = ShowPhotoViewImpl()
//        window = UIWindow()
//        setupViewController()
//    }
//    override func tearDown() {
//        sut = nil
//        window = nil
//        super.tearDown()
//    }
//
//
//
//    func test_init__expect_interactor_getPhotoWithId_isInvoked() {
//		// --- given.
//        let interactorSpy = InteractorSpy()
//        sut.interactor = interactorSpy
//
//        // --- when.
//        loadView()
//
//        // --- then.
//        XCTAssertTrue(interactorSpy.getPhotoInvoked)
//    }
//
//    func setupViewController() {
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        sut = storyboard.instantiateViewController(withIdentifier: "ShowPhotoViewImpl") as? ShowPhotoViewImpl
//    }
//    func loadView() {
//        window.addSubview(sut.view)
//        RunLoop.current.run(until: Date())
//    }
//
//    // ==================
//    // MARK: - test doubles
//    // ==================
//    class InteractorSpy: ShowPhotoInteractor {
//        var photoID: String?
//        var getPhotoInvoked = false
//        func getPhoto(width id: String) {
//            getPhotoInvoked = true
//        }
//    }
//}
