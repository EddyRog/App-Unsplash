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

    override func setUp() {
        super.setUp()
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
        let urlString = "https://api.unsplash.com/search?client_id=a76ebbad189e7f2ae725980590e4c520a525e1db029aa4cea87b44383c8a1ec4&query=car"
        let expectedURLRequest = URLRequest(url: URL(string: urlString)!)
        // --- when.
        let actualURLRequest = try? sut.makeURLRequest(withRequest: .urlRequest("car"))

        // --- then.
        assertNoDifference(expectedURLRequest, actualURLRequest)

    }
    func test_makeURLRequest_withID__expect_URLRequest() {
        // --- given.
        let expectedUrlString = "https://api.unsplash.com/photos/Xlo7N1ctmZc?client_id=a76ebbad189e7f2ae725980590e4c520a525e1db029aa4cea87b44383c8a1ec4"
        let expectedURLRequest = URLRequest(url: URL(string: expectedUrlString)!)

        // --- when.
        let actualURLRequest = try? sut.makeURLRequest(withRequest: .urlID("Xlo7N1ctmZc"))

        // --- then.
        assertNoDifference(expectedURLRequest, actualURLRequest)
    }

    func test_parseDataResponse_withJsonRequest_expect_ResponseDecoded() {
        // --- given.
        let stubbedData = fetchJsonDataFromLocalFile()
        let expectedResponseDescription = "Ford in to the wild"

        // --- when.
        let firstResponse = try? sut.parseResponse(data: stubbedData).photos.first
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

    // --- URLRequest + Parse.
    func test_retrievePhotos_withRequest__expect_response() {
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
