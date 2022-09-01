//
// SearchPhotosWorkerTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0


// URLRequest - request
// URLRequest - IDPhoto
// ParseResponse - Error
// ParseResponse - Decoded Request
// ParseResponse - Decoded PhotoID
// Request - MakeURLRequest + ParseResponse

@testable import App_Unsplash
import XCTest
import CustomDump

class PhotosWorkerTests: XCTestCase {

    var sut: PhotosWorker!
    static var photoID = "Xlo7N1ctmZc"
    var keyAPI = Constant.URL.urlQuery.cliendID.rawValue.value

    override func setUp() {
        super.setUp()
//        Constant.URL.queryItems[.client]
//        Constant.URL.queryItems
        sut = PhotosWorker()
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init_PhotosWorker__expect_notNil() {
        XCTAssertNotNil(sut)
    }

    func test_makeURLRequest_withST__expect_URLRequest() {
        // define righ request
        // --- given.
        let urlString = "https://api.unsplash.com/search?client_id=\(keyAPI)&query=car"
        let expectedURLRequest = URLRequest(url: URL(string: urlString)!)
        // --- when.
        let actualURLRequest = try? sut.makeURLRequest(withRequest: .urlRequest("car"))

        // --- then.
        assertNoDifference(expectedURLRequest, actualURLRequest)

    }
    func test_makeURLRequest_withID__expect_URLRequest() {
        // --- given.
        let expectedUrlString = "https://api.unsplash.com/photos/Xlo7N1ctmZc?client_id=\(keyAPI)"
        let expectedURLRequest = URLRequest(url: URL(string: expectedUrlString)!)

        // --- when.
        let actualURLRequest = try? sut.makeURLRequest(withRequest: .urlID("Xlo7N1ctmZc"))

        // --- then.
        assertNoDifference(expectedURLRequest, actualURLRequest)
    }

    func test_makeURLRequest_nextPageWithNilCurrentPAge__expect_URLRequestWithPageMinus2() {
        let actualUrlRequest = try? sut.makeURLRequest(withRequest: .nextPage(request: "car", currentPage: "-2"))

        let stringForExpectation = "https://api.unsplash.com/search?client_id=\(keyAPI)&query=car&page=2"
        let expected = URLRequest(url: URL(string: stringForExpectation)!)

        assertNoDifference(expected, actualUrlRequest)
    }
    func test_makeURLRequest_nextPageWithNilCurrentPAge__expect_URLRequestWithPage0() {
        let actualUrlRequest = try? sut.makeURLRequest(withRequest: .nextPage(request: "car", currentPage: "0"))

        let stringForExpectation = "https://api.unsplash.com/search?client_id=\(keyAPI)&query=car&page=2"
        let expected = URLRequest(url: URL(string: stringForExpectation)!)

        assertNoDifference(expected, actualUrlRequest)
    }
    func test_makeURLRequest_nextPageWithNilCurrentPAge__expect_URLRequestWithPage1() {
        let actualUrlRequest = try? sut.makeURLRequest(withRequest: .nextPage(request: "car", currentPage: "1"))

        let stringForExpectation = "https://api.unsplash.com/search?client_id=\(keyAPI)&query=car&page=2"
        let expected = URLRequest(url: URL(string: stringForExpectation)!)

        assertNoDifference(expected, actualUrlRequest)
    }
    func test_makeURLRequest_nextPageWithNilCurrentPAge__expect_URLRequestWithPage2() {
        let actualUrlRequest = try? sut.makeURLRequest(withRequest: .nextPage(request: "car", currentPage: nil))

        let stringForExpectation = "https://api.unsplash.com/search?client_id=\(keyAPI)&query=car&page=2"
        let expected = URLRequest(url: URL(string: stringForExpectation)!)

        assertNoDifference(expected, actualUrlRequest)
    }
    func test_makeURLRequest_nextPageWithNilCurrentPAge__expect_URLRequestWithPage3() {
        let actualUrlRequest = try? sut.makeURLRequest(withRequest: .nextPage(request: "car", currentPage: "2"))

        let stringForExpectation = "https://api.unsplash.com/search?client_id=\(keyAPI)&query=car&page=3"
        let expected = URLRequest(url: URL(string: stringForExpectation)!)

        assertNoDifference(expected, actualUrlRequest)
    }

    // --- Parse: retrievePhotos.
    func test_parseDataResponse_withJsonRequest_expect_ResponseDecoded() {
        // --- given.
        let stubbedData = fetchJsonDataFromLocalFile()
        let expectedResponseDescription = "Ford in to the wild"

        // --- when.
        let firstResponse = try? sut.parseResponse(data: stubbedData).photos.first
//        let actualResponsesID          = firstResponse?.
        let actualResponsesDescription = firstResponse?.description

        // --- then.
        assertNoDifference(expectedResponseDescription, actualResponsesDescription)
    }
    func test_parseDataResponse_withJson__expect_throwsError() {
        let stubbedata = "{ \"JsonKeyWrong\": 42 }".data(using: .utf8)!

        XCTAssertThrowsError(try sut.parseResponse(data: stubbedata),
                             "should thrown an error") { error in
            assertNoDifference(ServiceError.dataParse, error as! ServiceError)
        }
    }

    // --- Parse: retrievePhoto(withID.
    func test_parseDataResponse_withJsonRequestToShowPicture__expect_ResponseDecoded() {
		// --- given.
        let stubbedData = fetchJsonDataFromLocalFile(.photoID)
        let expectedResponseDescription = "description01"

        // --- when.
        let response = try? sut.parseResponse(dataPhotoID: stubbedData)

        assertNoDifference(expectedResponseDescription, response?.photo?.description)
    }

    // --- URLRequest + Parse / retrieve with string
    func test_retrievePhotos_withStringRequest__expect_response() {
        // --- given.
        // MARK: - Config the session with a mock URLProtocol to customize the response of fake server
        let urlSessionConfiguration = URLSessionConfiguration.ephemeral // no persitence for (credential, cache, cookie)
        urlSessionConfiguration.protocolClasses = [MockURLProtocol.self]

        // MARK: - Configure the session with `urlSessionConfiguration` for purpose of tests
        sut.session = URLSession(configuration: urlSessionConfiguration)

        // MARK: - Configure a stubbed response in the class `MockURLProtocol`
        MockURLProtocol.requestHandlerStubbed = { urlRequestPassed in
            // MARK: - Check the request when it s passed
            XCTAssertEqual(urlRequestPassed.url?.query?.contains("Car"), true)
            XCTAssertEqual(urlRequestPassed.url?.host?.contains("api.unsplash.com"), true)
            XCTAssertEqual(urlRequestPassed.url?.scheme?.contains("https"), true)

			let response = HTTPURLResponse()
            let data = self.fetchJsonDataFromLocalFile()
            return (response, data)
        }

        // --- when.
        let exp = expectation(description: "wait for retrievePhotos")
        sut.retrievePhotos(withRequest: "Car") { responseFromEXTWithPhotos in
            self.assertNoDifference("Ford in to the wild", responseFromEXTWithPhotos.first?.description)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)

    }

    // --- URLRequest + Parse / retrieve with ID
    func test_retrievePhotos_withIDRequest__expect_response() {
        // --- given.
        // MARK: - Config the session with a mock URLProtocol to customize the response of fake server
        let urlSessionConfiguration = URLSessionConfiguration.ephemeral // no persitence for (credential, cache, cookie)
        urlSessionConfiguration.protocolClasses = [MockURLProtocol.self]

        // MARK: - Configure the session with `urlSessionConfiguration` for purpose of tests
        sut.session = URLSession(configuration: urlSessionConfiguration)

        // MARK: - Configure a stubbed response in the class `MockURLProtocol`
        MockURLProtocol.requestHandlerStubbed = { urlRequestPassed in
            // MARK: - Check the request when it s passed
//            XCTAssertEqual(urlRequestPassed.url?.query?.contains("Car"), true)
//            XCTAssertEqual(urlRequestPassed.url?.host?.contains("api.unsplash.com"), true)
//            XCTAssertEqual(urlRequestPassed.url?.scheme?.contains("https"), true)

            let response = HTTPURLResponse()
            let data = self.fetchJsonDataFromLocalFile(.photoID)
            return (response, data)
        }

        // --- when.
        let exp = expectation(description: "wait for retrievePhotoByID")
        sut.retrievePhoto(withID: "1234") { unsafePhoto in
            self.assertNoDifference("description01", unsafePhoto?.description)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.5)
    }

    // --- URLRequest + Parse / retrieve with CurrentPage
    func test_retrievePhotos_withNextPage__expect_response() {
        // --- given.
        // MARK: - Config the session with a mock URLProtocol to customize the response of fake server
        let urlSessionConfiguration = URLSessionConfiguration.ephemeral // no persitence for (credential, cache, cookie)
        urlSessionConfiguration.protocolClasses = [MockURLProtocol.self]

        // MARK: - Configure the session with `urlSessionConfiguration` for purpose of tests
        sut.session = URLSession(configuration: urlSessionConfiguration)

        // MARK: - Configure a stubbed response in the class `MockURLProtocol`
        MockURLProtocol.requestHandlerStubbed = { urlRequestPassed in
            // MARK: - Check the request when it s passed

            let response = HTTPURLResponse()
            var data = Data()

            guard let urlpassed = urlRequestPassed.url?.query else {
                data = Data()
                return(response, data)
            }

            if urlpassed.contains("page=2") {
				data = self.fetchJsonDataFromLocalFile(.stubPage2)
            } else if urlpassed.contains("page=3") {
                data = self.fetchJsonDataFromLocalFile(.stubPage3)
            }

            return (response, data)
        }

        /*
        // --- when.
        let exp0 = expectation(description: "wait for currentPage with nil")
        sut.retrievePhotos(withRequest: "0000", currentPage: nil) { unsafePhoto in
            self.assertNoDifference("📄📄if page nil or 1 => Page2📄📄", unsafePhoto.first?.description!)
            exp0.fulfill()
        }
        wait(for: [exp0], timeout: 0.5)

        let exp1 = expectation(description: "")
        sut.retrievePhotos(withRequest: "0000", currentPage: "2") { unsafePhoto in
            self.assertNoDifference("📊📊if page 2 => Page3📊📊", unsafePhoto.first?.description!)
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 0.5)


        let exp2 = expectation(description: "wait for currentPage with nil")
        sut.retrievePhotos(withRequest: "0000", currentPage: "4") { unsafePhoto in
            self.assertNoDifference(nil, unsafePhoto.first?.description!)
            exp2.fulfill()
        }
        wait(for: [exp2], timeout: 0.5)
         */
    }


    // ==================
    // MARK: - Test doubles
    // ==================
    class MockURLProtocol: URLProtocol {

        static var requestHandlerStubbed: ( (URLRequest) -> (HTTPURLResponse, Data) )?

        override class func canInit(with request: URLRequest) -> Bool {
            // ask if we can handle a request in this sub class
            return true
        }

        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            /*
             canonical means = request that respect a specific commun format like URLRequest...
             (e.g https://myWebSite.com/?search="car")
             protocol => https
             host     => www.myWebSite.com
             query    => search="car"
             */
            return request
        }

        override func startLoading() {
			// low-level setting, here I make a custom connection or something else
            guard let unwRequestHandlerStubbed =  MockURLProtocol.requestHandlerStubbed else {
                XCTFail("should implement the request")
                return
            }

            // exec the closure to sets the request passed in the impl
            let (responseStubbed, dataStubbed) = unwRequestHandlerStubbed(request)

            let response = responseStubbed
            let data = dataStubbed

            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        }

        override func stopLoading() { }
    }

    // ==================
    // MARK: - Helper
    // ==================
    private func fetchJsonDataFromLocalFile(_ jsonFile: JsonFile = .request) -> Data {
        var nameOfFile = ""

        let extensionOfFile = "json"
        switch jsonFile {
            case .request:
                nameOfFile = "StubAPI"
            case .photoID:
                nameOfFile = "StubPhotoID"
            case .stubPage2:
                nameOfFile = "StubPage2"
            case .stubPage3:
                nameOfFile = "StubPage3"
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
        case stubPage2
        case stubPage3
    }
}


