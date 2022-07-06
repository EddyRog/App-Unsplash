//
// ParserSearchPhotosTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0
@testable import App_Unsplash
import XCTest
import CustomDump

// https://api.unsplash.com/search/?query=Bird&client_id=a76ebbad189e7f2ae725980590e4c520a525e1db029aa4cea87b44383c8a1ec4

class SearchPhotosParserTests: XCTestCase {
    var sut: SearchPhotosParserImpl!

    var jsonData: Data? {
		return makeJsonFile(name: .complexe)
    }
    var stubbedDescription = "⇉ Lightroom CC IG: @unprophotogab"
    var stubbedPicture = "https://images.unsplash.com/photo-1592847902295-c87f74e6a7f1?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=Mnw1NDcwN3wwfDF8c2VhcmNofDF8fHZvaXR1cmV8ZW58MHx8fHwxNjU2NDE2ODIy&ixlib=rb-1.2.1&q=80&w=200"

    override func setUp() {
        super.setUp()
        sut = SearchPhotosParserImpl()
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_parse_expect_arrayOfPhotoNotNil() throws {
        // --- given.
        guard let jsonData = self.jsonData else { return }

        // --- when.
        guard let photosParsed = sut.parse(with: jsonData) else { return }
        let photos = sut.extract(with: photosParsed)

        // --- then.
        XCTAssertFalse(photos.isEmpty)
        assertNoDifference(stubbedDescription, photos.first?.description)
        assertNoDifference(stubbedPicture, photos.first?.picture)
        XCTAssertNotEqual(photosParsed, CodableParserSearchPhotos(photos: nil))
        XCTAssertNotEqual(photosParsed.photos, CodablePhotos(results: []))
        XCTAssertNotEqual(photosParsed.photos?.results, [CodableResult()])
        XCTAssertNotEqual(photosParsed.photos?.results.first?.urls, CodableUrl())
        XCTAssertNotEqual(photosParsed.photos?.results.first?.description, "description")
    }

    func test_parse_expect_nilwhenParsing() {
        // --- given.
        sut.decoder = nil

        // --- when.
        guard let jsonData = makeJsonFile(name: .complexe) else { return }

        // --- then.
        assertNoDifference(nil, sut.parse(with: jsonData))

    }

    func test_urlRequestObjc_expect_urlString() {
        // --- given.
        let objc = URLRequestObjc(
            scheme: "https",
            host: "api.unsplash.com",
            path: "/search/")

        // --- when.
        let actualUrlString = objc.build(request: "car")

        // --- then.
        let expectedRequestUrl = "https://api.unsplash.com/search/?query=car&client_id="
        assertNoDifference(expectedRequestUrl, actualUrlString)
    }

    // build query
    func test_buildUrlQuery_withString_expect_goodUrl() {
        let expected = "https://api.unsplash.com/search/?query=Bird&client_id="
        let actualdUrlString = sut.buildUrlQuery(with: "Bird")
        assertNoDifference(expected, actualdUrlString)
    }

}

extension SearchPhotosParserTests {
    // path url data print
    func makeJsonFile(name: JsonSelector) -> Data? {

        guard let jsonPath = Bundle.main.path(forResource: name.rawValue, ofType: ".json") else {
			fatalError("jsonPath")
            }
        let jsonURL = URL(fileURLWithPath: jsonPath)
        guard let jsonData = try? Data(contentsOf: jsonURL, options: .mappedIfSafe) else {
            fatalError("jsonPath")
            }
        if let dataDescription = String(data: jsonData, encoding: .utf8) {
            print("🟧🟧🟧")
            print(dataDescription)
            print("🟧🟧🟧")
        }

		return jsonData
    }

}

enum JsonSelector: String {
    case simple = "SimpleData"
    case complexe = "StubAPI"
}
