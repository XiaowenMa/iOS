//
//  IGDBTests.swift
//  VENI VIDITests
//
//  Created by 雲無心 on 4/13/21.
//

@testable import VENI_VIDI
import UIKit
import XCTest

class IGDBTests: XCTestCase {
    // MARK: - Properties and Set Up

    var igdbAgent: IGDBSearchAgent!

    override func setUp() {
        super.setUp()
        igdbAgent = IGDBSearchAgent()
    }

    override func tearDown() {
        igdbAgent = nil
        super.tearDown()
    }

    // MARK: - Behavior Tests

    func testValidQuery() {
        let testExpectation = expectation(description: "IGDB EVE Online test")
        let timeStamp = Date().timeIntervalSince1970

        igdbAgent.query(withKeyword: "EVE Online", withTimeStamp: timeStamp) { result in
            switch result {
            case let .success(queryResult):
                XCTAssertGreaterThan(queryResult.count, 0)
                XCTAssertEqual(queryResult.first?.timeStamp, timeStamp)
                XCTAssertNotNil(queryResult.first?.coverUrl)
                XCTAssertNotNil(URL(string: queryResult.first?.coverUrl ?? ""))
                testExpectation.fulfill()
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testInvalidQuery() {
        let testExpectation = expectation(description: "IGDB no result test")

        igdbAgent.query(withKeyword: "qwerzxcvasdfjlk;",
                        withTimeStamp: Date().timeIntervalSince1970) { result in
            switch result {
            case let .success(queryResult):
                XCTAssertEqual(queryResult.count, 0)
                testExpectation.fulfill()
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    // MARK: - Performance Tests

    func testPerformanceValidQuery() {
        measure {
            let testExpectation = expectation(description: "IGDB EVE Online test")
            let timeStamp = Date().timeIntervalSince1970

            igdbAgent.query(withKeyword: "EVE Online", withTimeStamp: timeStamp) { result in
                switch result {
                case let .success(queryResult):
                    XCTAssertGreaterThan(queryResult.count, 0)
                    XCTAssertEqual(queryResult.first?.timeStamp, timeStamp)
                    testExpectation.fulfill()
                case let .failure(error):
                    XCTFail(error.localizedDescription)
                }
            }

            waitForExpectations(timeout: 10, handler: nil)
        }
    }

    func testPerformanceInvalidQuery() {
        measure {
            let testExpectation = expectation(description: "IGDB no result test")

            igdbAgent.query(withKeyword: "qwerzxcvasdfjlk;",
                            withTimeStamp: Date().timeIntervalSince1970) { result in
                switch result {
                case let .success(queryResult):
                    XCTAssertEqual(queryResult.count, 0)
                    testExpectation.fulfill()
                case let .failure(error):
                    XCTFail(error.localizedDescription)
                }
            }

            waitForExpectations(timeout: 10, handler: nil)
        }
    }
}
