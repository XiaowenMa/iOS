//
//  TMDBTVTests.swift
//  VENI VIDITests
//
//  Created by 雲無心 on 4/13/21.
//

@testable import VENI_VIDI
import UIKit
import XCTest

class TMDBTVTests: XCTestCase {
    // MARK: - Properties and Set Up

    var tmdbTVAgent: TMDBTVSearchAgent!

    override func setUp() {
        super.setUp()
        tmdbTVAgent = TMDBTVSearchAgent()
    }

    override func tearDown() {
        tmdbTVAgent = nil
        super.tearDown()
    }

    // MARK: - Behavior Tests

    func testValidQuery() {
        let testExpectation = expectation(description: "TMDB TV Show Sense8 test")
        let timeStamp = Date().timeIntervalSince1970

        tmdbTVAgent.query(withKeyword: "Sense8", withTimeStamp: timeStamp) { result in
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
        let testExpectation = expectation(description: "TMDB TV Show no result test")

        tmdbTVAgent.query(withKeyword: "qwerzxcvasdfjlk;",
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

    func testRandomRecommendation() {

        let coreDataStack = TestCoreDataStack()
        let dataService = DataService(coreDataStack: coreDataStack)

        dataService.createJournalEntry(aboutWork: "Sense8", withType: .tvShow)

        let expectation = expectation(description: "Expection for Sense8-based random recommendation")
        tmdbTVAgent.getRandomRecommendation(withDataStack: coreDataStack) { reuslt in
            switch reuslt {
            case let .success(results):
                XCTAssertGreaterThan(results.count, 0)
                expectation.fulfill()
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    // MARK: - Performance Tests

    func testPerformanceValidQuery() {
        measure {
            let testExpectation = expectation(description: "TMDB TV Show Sense8 test")

            tmdbTVAgent.query(withKeyword: "Sense8",
                              withTimeStamp: Date().timeIntervalSince1970) { result in
                switch result {
                case let .success(queryResult):
                    XCTAssertGreaterThan(queryResult.count, 0)
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
            let testExpectation = expectation(description: "TMDB TV Show no result test")

            tmdbTVAgent.query(withKeyword: "qwerzxcvasdfjlk;",
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
