//
// FetcherSearchPhotosTests.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0
@testable import App_Unsplash
import XCTest
import CustomDump

class SearchPhotosFetcherTests: XCTestCase {
    var sut: FetcherSearchPhotosImpl!
    var parserSpy: ParserSearchPhotosSpy!

    override func setUp() {
        super.setUp()
        sut = FetcherSearchPhotosImpl()
        parserSpy = ParserSearchPhotosSpy()
        sut.parser = parserSpy
    }
    override func tearDown() {
        sut = nil
        parserSpy = nil
        super.tearDown()
    }

    func test_init_fetcher_expect_notNil() {
        XCTAssertNotNil(sut)
    }

    func test_fetcher_withParser_expect_parserNotNil() {
        XCTAssertNotNil(sut.parser)
    }

    func test_fetch_withEmptyRequest_expect_ArrayOfEmptyPhotos() {
        // --- given.
        let request = "_"
        var actualPhotos = [Photo]()
        let expectedPhotos = [Photo]()

        // --- when.
        let exp = expectation(description: "expected : wait expectation")
        sut.fetch(with: request) { photos in
            actualPhotos = photos
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.05)

        // --- assert.
        assertNoDifference(expectedPhotos, actualPhotos)
    }

    // ==================
    // MARK: - Tests double
    // ==================
    class ParserSearchPhotosSpy: SearchPhotosParser {
        var decoder: JSONDecoder?
        var resultOfURLRequest: String?

        func parse(with jsonData: Data) -> CodableParserSearchPhotos? {
			return nil
        }

        func extract(with alldataDecoded: CodableParserSearchPhotos) -> [Photo] {
			return []
        }
    }
}

// what is important ?  the acation ( login ,
// what test ? = the actions, 1 class / action
