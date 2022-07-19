////
//// ShowPhotoViewTests.swift
//// App-UnsplashTests
//// Created in 2022
//// Swift 5.0
//
//@testable import App_Unsplash
//import XCTest
//
//
//class ShowPhotoViewTests: XCTestCase {
//    var sut: ShowPhotoViewImpl!
//    var window: UIWindow!
//
//    override func setUp() {
//        super.setUp()
//        sut = ShowPhotoViewImpl()
//        window = UIWindow()
//        setupShowPhotoView()
//    }
//    override func tearDown() {
//        sut = nil
//        super.tearDown()
//    }
//
//    func test_xctfail() {
//        XCTAssertNotNil(ShowPhotoViewImpl())
//    }
//
//    func setupShowPhotoView() {
//        let bundle = Bundle.main
//        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
//        sut = storyboard.instantiateViewController(withIdentifier: "ShowPhotoView") as? ShowPhotoViewImpl
//    }
//
//    func loadView() {
//        window.addSubview(sut.view)
//        RunLoop.current.run(until: Date())
//    }
//
//    func test_init_ShowPhotoImpl_expect_interactorOnGetPhotoInvoked() {
//        let showPhotoInteractorSpy = InteractorSpy()
//        sut.interactor = showPhotoInteractorSpy
//
//        loadView()
//
//        XCTAssert(showPhotoInteractorSpy.getPhotoInvoked)
//    }
//
//    // ==================
//    // MARK: - testDouble
//    // ==================
//    class InteractorSpy: ShowPhotoInteractor {
//        var getPhotoInvoked = false
//
//        func getPhoto(with id: String) {
//            getPhotoInvoked = true
//        }
//    }
//}
//
//
