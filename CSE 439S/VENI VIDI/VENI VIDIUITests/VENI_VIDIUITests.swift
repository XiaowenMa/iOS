//
//  VENI_VIDIUITests.swift
//  VENI VIDIUITests
//
//  Created by 雲無心 on 2/12/21.
//

@testable import VENI_VIDI
import XCTest

class VENI_VIDIUITests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // timeline label exist
        XCTAssert(app.staticTexts["February"].exists)

        // Test if there is image for the Avengers entry
        let imageView = app.images
        XCTAssertGreaterThan(imageView.count, 0)
        XCTAssert(imageView["Avengers"].exists)

        // Tab on a certain entry, try to edit/re-rate a movie
        let tablesQuery = app.tables

        tablesQuery/*@START_MENU_TOKEN@*/ .cells.staticTexts["Avengers"]/*[[".cells.staticTexts[\"Avengers\"]",".staticTexts[\"Avengers\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/ .tap()

        XCTAssert(app.staticTexts["3/18/21"].exists)
        XCTAssert(app.staticTexts["Avengers"].exists)

        let backButton = app.navigationBars["VENI_VIDI.DetailedEntryView"].buttons["Back"]

        let editButton = app.navigationBars["VENI_VIDI.DetailedEntryView"].buttons["Edit"]
        editButton.tap()
        app.navigationBars["VENI_VIDI.UpdateEnrtyView"].buttons["Back"].tap()

        tablesQuery/*@START_MENU_TOKEN@*/ .otherElements["Rating"]/*[[".cells.otherElements[\"Rating\"]",".otherElements[\"Rating\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .tap()

        backButton.tap()

        // Test adding new Entry page
        app.navigationBars["VENI_VIDI.TimelineView"].buttons["Add"].tap()
        XCTAssert(app.textViews["Entry Title"].exists)
        XCTAssert(app.textViews["Entry Note"].exists)
        app.navigationBars["VENI_VIDI.UpdateEnrtyView"].buttons["Back"].tap()

        tablesQuery.cells.staticTexts["Journal 0"].tap()
        backButton.tap()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
