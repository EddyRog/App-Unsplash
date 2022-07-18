//
// Extension+XCTestCase.swift
// App-UnsplashTests
// Created in 2022
// Swift 5.0


import Foundation
import CustomDump
import XCTest

extension XCTestCase {
    /** see also NotIdentical, Identical, Different */
    func assertNoDifference<T: Equatable>(_ expected: T, _ was: T, line: Int = #line) {
        XCTAssertNoDifference(expected, was, "  \n 🔽🔽🔽\n 🚀L-\(line)  |  ❇️expected: \(expected),  ❌was: \(was) \n   🔼🔼🔼\n")
    }
}
