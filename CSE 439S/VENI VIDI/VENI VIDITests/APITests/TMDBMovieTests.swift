//
//  TMDBTests.swift
//  VENI VIDITests
//
//  Created by 雲無心 on 4/12/21.
//

@testable import VENI_VIDI
import UIKit
import XCTest

class TMDBMovieTests: XCTestCase {
    // MARK: - Properties and Set Up

    var tmdbMovieAgent: TMDBMovieSearchAgent!

    override func setUp() {
        super.setUp()
        tmdbMovieAgent = TMDBMovieSearchAgent()
    }

    override func tearDown() {
        tmdbMovieAgent = nil
        super.tearDown()
    }

    // MARK: - Behavior Tests

    func testValidQuery() {
        let testExpectation = expectation(description: "TMDB Movie Interstellar test")
        let timeStamp = Date().timeIntervalSince1970

        tmdbMovieAgent.query(withKeyword: "Interstellar", withTimeStamp: timeStamp) { result in
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
        let testExpectation = expectation(description: "TMDB Movie no result test")

        tmdbMovieAgent.query(withKeyword: "qwerzxcvasdfjlk;", withTimeStamp: Date().timeIntervalSince1970) { result in
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

        dataService.createJournalEntry(aboutWork: "Interstellar", withType: .movie)

        let testExpectation = expectation(description: "Expection for Interstellar-based random recommendation")
        tmdbMovieAgent.getRandomRecommendation(withDataStack: coreDataStack) { reuslt in
            switch reuslt {
            case let .success(results):
                XCTAssertGreaterThan(results.count, 0)
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
            let testExpectation = expectation(description: "TMDB Movie Interstellar test")

            tmdbMovieAgent.query(withKeyword: "Interstellar", withTimeStamp: Date().timeIntervalSince1970) { result in
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
            let testExpectation = expectation(description: "TMDB Movie no result test")

            tmdbMovieAgent.query(withKeyword: "qwerzxcvasdfjlk;",
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
