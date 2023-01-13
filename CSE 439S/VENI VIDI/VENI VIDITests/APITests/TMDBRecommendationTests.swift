//
//  TMDBRecommendationTests.swift
//  VENI VIDITests
//
//  Created by 雲無心 on 4/28/21.
//

@testable import VENI_VIDI
import UIKit
import XCTest

class TMDBRecommendationTests: XCTestCase {
    // MARK: - Properties and Set Up

    var tmdbTVAgent: TMDBTVSearchAgent!
    var tmdbMovieAgent: TMDBMovieSearchAgent!
    var testDataStack: CoreDataStack!
    var dataService: DataService!

    override func setUp() {
        super.setUp()
        testDataStack = TestCoreDataStack()
        dataService = DataService(coreDataStack: testDataStack)
        tmdbTVAgent = TMDBTVSearchAgent()
        tmdbMovieAgent = TMDBMovieSearchAgent()
    }

    override func tearDown() {
        tmdbTVAgent = nil
        testDataStack = nil
        dataService = nil
        super.tearDown()
    }

    // MARK: - Behavior Tests

    func testTVRecommendation() {

        dataService.createJournalEntry(aboutWork: "Sense8", withType: .tvShow)

        let testExpectation = expectation(description: "TMDB TV Show get recommendation from Sense8")

        tmdbTVAgent.getRandomRecommendation(withDataStack: testDataStack) { result in
            switch result {
            case let .success(results):
                XCTAssertFalse(results.isEmpty)
                testExpectation.fulfill()
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testMovieRecommendation() {

        dataService.createJournalEntry(aboutWork: "Interstellar", withType: .movie)

        let testExpectation = expectation(description: "TMDB Movie get recommendation from Interstellar")

        tmdbMovieAgent.getRandomRecommendation(withDataStack: testDataStack) { result in
            switch result {
            case let .success(results):
                XCTAssertFalse(results.isEmpty)
                testExpectation.fulfill()
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
    }
}
