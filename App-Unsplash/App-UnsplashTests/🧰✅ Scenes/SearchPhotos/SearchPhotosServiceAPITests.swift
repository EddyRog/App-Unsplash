//
// SearchPhotosServiceAPITests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0

@testable import App_Unsplash
import XCTest
import CustomDump

class SearchPhotosServiceAPITests: XCTestCase {
    var sut: SearchPhotosServiceAPI!

    override func setUp() {
        super.setUp()
        sut = SearchPhotosServiceAPI()
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_serviceApi_whenInit_expect_isNotNil() {
        XCTAssertNotNil(sut)
    }

    // Make URL
    func test_makeURL_withRequest_expect_goodUrlWithStringGiven() {
        let stringURL = "https://api.unsplash.com/search/?query=car&client_id=a76ebbad189e7f2ae725980590e4c520a525e1db029aa4cea87b44383c8a1ec4"

        let actualURL = try? sut.makeURL(with: "car")
        let expectedURL = URL(string: stringURL)

        assertNoDifference(expectedURL, actualURL)
    }
    func test_makeURL_withRequest_expect_WrongUrlWithString() {
        let stringUrl = "https://api.unsplash.com/search/?query=car&client_id=a76ebbad189e7f2ae725980590e4c520a525e1db029aa4cea87b44383c8a1ec4"
        let expectedRequest = URL(string: stringUrl)
        let actualRequest = try? sut.makeURL(with: "Cat")
        XCTAssertNotEqual(expectedRequest,actualRequest)
    }

    // MakeURLRequest
    func test_makeURLRequest_withURL_expect_WrongURLRequest() {
        let unsplashURL = URL(string: "_")!
        let unsplashURL2 = URL(string: "__")!
        let actualURLRequest = try? sut.makeURLRequest(url: unsplashURL)
        let expectedURLRequest = URLRequest(url: unsplashURL2)
        XCTAssertNotEqual(expectedURLRequest, actualURLRequest)
    }
    func test_makeURLRequest_withURL_expect_URLURLRequest() {
        let urlProvided = URL(string: "https://www.google.com/?position=1")!
        let urlRequest = try? sut.makeURLRequest(url: urlProvided)
        assertNoDifference("https", urlRequest?.url?.scheme)
        assertNoDifference("www.google.com", urlRequest?.url?.host)
        assertNoDifference("position=1", urlRequest?.url?.query)
    }

    // ParseResponse
    func test_parseDataResponse_withJson_expect_throwsError() {
		let stubbedData = "{ \"JsonKeyWrong\": 42 }".data(using: .utf8)!
        XCTAssertThrowsError(try sut.parseResponse(data: stubbedData),
                             "should throwns error") { error in
            assertNoDifference(ServiceError.dataParse, error as! ServiceError)
        }
    }
    func test_parseDataResponse_withJson_expect_ResponseDecoded() {
        // --- given.
        let stubbedData = fetchJsonDataFromLocalFile()
        let expectedResponseDescription = "Ford in to the wild"
        let expectedResponseUrlsSmall = "https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=Mnw1NDcwN3wwfDF8c2VhcmNofDF8fGNhcnxlbnwwfHx8fDE2NTgxNjA2NDA&ixlib=rb-1.2.1&q=80&w=400"
        let expectedResponseID = "a4S6KUuLeoM"

		// --- when.
        let firstResponse = try? sut.parseResponse(data: stubbedData).first

        let actualResponsesDescription = firstResponse?.description
        let actualResponsesUrlsSmall = firstResponse?.urlSmall
        let actualResponsesID = firstResponse?.id

        assertNoDifference(expectedResponseDescription, actualResponsesDescription)
        assertNoDifference(expectedResponseUrlsSmall, actualResponsesUrlsSmall)
        assertNoDifference(expectedResponseID, actualResponsesID)
    }

    // Make URL, MakeURLRequest, ParseResponse
    func test_givenServiceAPI_whenSearchPhoto_expect_response() {
        // --- given.
        // MARK: - Config the session with a mock URLProtcol to customize the response of fake server
        let configuration = URLSessionConfiguration.ephemeral // no persistence for (credential, cache, cookie)
        configuration.protocolClasses = [MockUrlProtocol.self]

        // MARK: - set the session with our configuration for purpose of test
        sut.session = URLSession(configuration: configuration)

        // MARK: - Setup a stubbed response in our MockUrlProtocol
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
        sut.searchPhotos(with: "Car") { responsesFromeExtClasses in

            // --- then.
            self.assertNoDifference("Ford in to the wild", responsesFromeExtClasses.first?.description)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
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

    private func fetchJsonDataFromLocalFile() -> Data {
        // MARK: - Get file Path
        let nameOfFile = "StubAPI"
        let extensionOfFile = "json"
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
}
