//
// ShowPhotoInteractorTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

import XCTest
@testable import App_Unsplash

class ShowPhotoInteractorTests: XCTestCase {

    var sut: ShowPhotoInteractor!
    var photoWorkerSPY: PhotosWorkerSPY!
    var showPhotoPresenterSPY: ShowPhotoPresenterSPY!

    override func setUp() {
        super.setUp()
        sut = ShowPhotoInteractor()
        photoWorkerSPY = PhotosWorkerSPY()
        showPhotoPresenterSPY = ShowPhotoPresenterSPY()
        sut.worker = photoWorkerSPY
        sut.presenter = showPhotoPresenterSPY
    }
    override func tearDown() {
        sut = nil
        photoWorkerSPY = nil
        showPhotoPresenterSPY = nil
        super.tearDown()
    }

    func test_init_ShowPhotoInteractor__expect_notNil() {
        XCTAssertNotNil(sut)
    }

    func test_retrievePhoto_withID__expect_invokedWorkerAndPresenter() {
        sut.retrievePhoto(withID: ShowPhoto.FetchPhoto.Request.init(query: "0"))

        XCTAssertTrue(photoWorkerSPY.invokedPhotosWorker)
        XCTAssertTrue(showPhotoPresenterSPY.invokedPresenter)
    }

    func test_retrievePhoto_withID__expect_noPhoto() {
        let dummyRequest = ShowPhoto.FetchPhoto.Request.init(query: "")
        photoWorkerSPY.makeDataPhoto = nil

        sut.retrievePhoto(withID: dummyRequest)

        XCTAssertNil(showPhotoPresenterSPY.resultResponse.photo)
    }
    func test_retrievePhoto_withID__expect_Photo() {
        let dummyRequest = ShowPhoto.FetchPhoto.Request.init(query: "")
        photoWorkerSPY.makeDataPhoto = Photo(description: "Photo")

        sut.retrievePhoto(withID: dummyRequest)

        XCTAssertNotNil(showPhotoPresenterSPY.resultResponse.photo)
        if let photoDescription = showPhotoPresenterSPY.resultResponse.photo?.description {
			assertNoDifference("Photo", photoDescription)
        }
    }

    // ==================
    // MARK: - Test doubles
    // ==================
    class PhotosWorkerSPY: PhotosWorkerLogic {

        var invokedPhotosWorker: Bool!
        var makeDataPhoto: Photo? = Photo.init(description: "")

        func retrievePhotos(withRequest request: String, complectionRetrieve: @escaping ([Photo]) -> Void) { }
        func retrievePhoto(withID request: String, completionRetrieve: @escaping (Photo?) -> Void ) {
            invokedPhotosWorker = true
            completionRetrieve(makeDataPhoto)
        }
    }

    class ShowPhotoPresenterSPY: ShowPhotoPresentationLogic {
        var invokedPresenter: Bool!
        var resultResponse: ShowPhoto.FetchPhoto.Response!

        func presentRetrievePhoto(with response: ShowPhoto.FetchPhoto.Response) {
            invokedPresenter = true
			resultResponse = response
        }
    }
}
