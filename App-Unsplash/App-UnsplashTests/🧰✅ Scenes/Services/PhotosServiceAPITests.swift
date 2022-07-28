//
// SearchPhotosServiceAPITests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest
import CustomDump

class PhotosServiceAPITests: XCTestCase {
    var sut: PhotosServiceAPI!
    static var photoID = "Xlo7N1ctmZc"

    override func setUp() {
        super.setUp()
        sut = PhotosServiceAPI()
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_serviceApi_whenInit_expect_isNotNil() {
        XCTAssertNotNil(sut)
    }

    // URLRequest - request
    func test_givenURLString_whenMakeURLRequest_withRequest__expect_URLRequestWithRequest() {
        // --- given.
        let expectedUrlString = "https://api.unsplash.com/search?client_id=a76ebbad189e7f2ae725980590e4c520a525e1db029aa4cea87b44383c8a1ec4&query=car"
        let expectedURLRequest = URLRequest(url: URL(string: expectedUrlString)!)

        // --- when.
        let actualURLRequest = try? sut.makeURLRequest(with: .urlRequest("car"))

        // --- then.
        assertNoDifference(expectedURLRequest, actualURLRequest)
    }
    // URLRequest - IDPhoto
    func test_givenURLString_whenMakeURLRequest_withID__expect_URLRequestWithID() {
        // --- given.
        let expectedUrlString = "https://api.unsplash.com/photos/Xlo7N1ctmZc?client_id=a76ebbad189e7f2ae725980590e4c520a525e1db029aa4cea87b44383c8a1ec4"
        let expectedURLRequest = URLRequest(url: URL(string: expectedUrlString)!)

        // --- when.
        let actualURLRequest = try? sut.makeURLRequest(with: .urlID("Xlo7N1ctmZc"))

        // --- then.
        assertNoDifference(expectedURLRequest, actualURLRequest)
    }
    // ParseResponse - Error
    func test_parseDataResponse_withJson_expect_throwsError() {
		let stubbedData = "{ \"JsonKeyWrong\": 42 }".data(using: .utf8)!
        XCTAssertThrowsError(try sut.parseResponse(data: stubbedData), "should throwns error") { error in
            assertNoDifference(ServiceError.dataParse, error as! ServiceError)
        }
    }
    // ParseResponse - Decoded Request
    func test_parseDataResponse_withJsonRequest_expect_ResponseDecoded() {
        // --- given.
        let stubbedData = fetchJsonDataFromLocalFile()
        let expectedResponseDescription = "Ford in to the wild"
//        let expectedResponseUrlsSmall = "https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=Mnw1NDcwN3wwfDF8c2VhcmNofDF8fGNhcnxlbnwwfHx8fDE2NTgxNjA2NDA&ixlib=rb-1.2.1&q=80&w=400"
//        let expectedResponseID = "a4S6KUuLeoM"

		// --- when.
        let firstResponse = try? sut.parseResponse(data: stubbedData).photos.first


        let actualResponsesDescription = firstResponse?.description
//        let actualResponsesUrlsSmall = firstResponse?.urlSmall
//        let actualResponsesID = firstResponse?.id

        assertNoDifference(expectedResponseDescription, actualResponsesDescription)
//        assertNoDifference(expectedResponseUrlsSmall, actualResponsesUrlsSmall)
//        assertNoDifference(expectedResponseID, actualResponsesID)
    }
    // ParseResponse - Decoded PhotoID
    func test_parseDataResponse_withJsonPhotoID_expect_ResponseDecoded() {
        // --- given.
        let jsonDataPhotoID = fetchJsonDataFromLocalFile(.photoID)
        let expectedPhotoResponse = ShowPhoto.FetchBook.Response(photo: Photo(description: "No description"))
        // --- when.
        let actualPhotoResponse = try? sut.parseResponseForPhotoID(data: jsonDataPhotoID)
        // --- then.
        assertNoDifference(expectedPhotoResponse, actualPhotoResponse)

    }
    // Request - MakeURLRequest + ParseResponse
    func test_givenServiceAPI_whenFetchPhoto_withRequest_expect_response() {
        // --- given.
        // MARK: - Config the session with a mock URLProtcol to customize the response of fake server
        let configuration = URLSessionConfiguration.ephemeral // no persistence for (credential, cache, cookie)
        configuration.protocolClasses = [MockUrlProtocol.self]

        // MARK: - set the session with our configuration for purpose of test
        sut.session = URLSession(configuration: configuration)

        // MARK: - Setup a stubbed response in our MockUrlProtocol =
        MockUrlProtocol.requestHandlerStubbed = { urlRequestPassed in

            // MARK: - Check the request when it s passed
            XCTAssertEqual(urlRequestPassed.url?.query?.contains("Car"), true)
            XCTAssertEqual(urlRequestPassed.url?.host?.contains("api.unsplash.com"), true)
            XCTAssertEqual(urlRequestPassed.url?.scheme?.contains("https"), true)

            // send back to the receiver
            let response = HTTPURLResponse()
            let data = self.fetchJsonDataFromLocalFile()
            return (response, data)
        }

        // --- when.
        let exp = expectation(description: "wait searchPhoto()")
        sut.fetchPhotos(withRequest: "Car") { responseFromEXTWithPhotos in
            self.assertNoDifference("Ford in to the wild", responseFromEXTWithPhotos.first?.description)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    // PhotoID - MakeURLRequest + ParseResponse
    func test_givenServiceAPI_whenFetchPhoto_withID_expect_response() {
        // --- given.
        // config the session with a fake classes to customize the response of fake server
        let configuration = URLSessionConfiguration.ephemeral // no persistence for (credential, cache, cookie)
        configuration.protocolClasses = [MockUrlProtocol.self] // defines a fake class that inherits from URLProtocol

        // defines the session with the setting above
        sut.session = URLSession(configuration: configuration)

        // setup a stubbed response in our MockUrlProtocol
        MockUrlProtocol.requestHandlerStubbed = { urlRequestPassed in
            // Check URL
            XCTAssertEqual(urlRequestPassed.url?.path, "/photos/\(PhotosServiceAPITests.photoID)")
            // Send back to the receiver
            let response = HTTPURLResponse()
            let data = self.fetchJsonDataFromLocalFile(.photoID)
            return (response, data)
        }

        // --- when.
        let exp = expectation(description: "expected : wait fetchPhoto(withID) ")
        sut.fetchPhoto(withID: PhotosServiceAPITests.photoID) { photo in
            XCTAssertEqual("No description", photo.description)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.05)
    }

    // ==================
    // MARK: - Test doubles
    // ==================
    class MockUrlProtocol: URLProtocol {
        static var requestHandlerStubbed: ( (URLRequest) -> (HTTPURLResponse, Data) )?

        override class func canInit(with request: URLRequest) -> Bool {
            // ask if we can handle a request in this sub class
            return true
        }
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            // canonical means =  request that respect a specifique commun format like URLRequest...
            // (e.g https://myWebSite.com/?search="car")
            // protocol : https
            // host www.myWebSite.com
            // query search="car"
            return request
        }
        override func startLoading() {
            // low level of setting
            // here make a custom connection or something else

            guard let unwRequestHandlerStubbed = MockUrlProtocol.requestHandlerStubbed else { XCTFail("should impl the request"); return }

            // exe the closure for setting with the request passed in impl service
            let (responseStubbed, dataStubbed) = unwRequestHandlerStubbed(request)

			let response = responseStubbed
            let data = dataStubbed

            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        }
        override func stopLoading() { }
    }

    private func fetchJsonDataFromLocalFile(_ jsonFile: JsonFile = .request) -> Data {
        var nameOfFile = ""

        let extensionOfFile = "json"
        switch jsonFile {
            case .request:
                nameOfFile = "StubAPI"
            case .photoID:
                nameOfFile = "StubPhotoID"
        }

        // MARK: - Get file Path
        guard let pathJson = Bundle.main.path(forResource: nameOfFile, ofType: extensionOfFile) else {
            fatalError("Failed to find \(nameOfFile).\(extensionOfFile)")
        }

        // MARK: - Stringlify content of File
        guard let contentJsonFile = try? String(contentsOfFile: pathJson) else {
            fatalError("Failed to get content of \(String(describing: pathJson)) from bundle.")
        }

        // MARK: - Map content to data type
        guard let dataJson = contentJsonFile.data(using: .utf8) else {
            fatalError("Failed to transform \(contentJsonFile) in data type.")
        }

        return dataJson
    }

    enum JsonFile {
        case request
        case photoID
    }
}
