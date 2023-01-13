//
//  JournalEntryTests.swift
//  VENI VIDITests
//
//  Created by 雲無心 on 4/28/21.
//

@testable import VENI_VIDI
import UIKit
import XCTest

extension DataServiceTests: DataServiceDelegate {

    func fetchAllJournalEntriesResultDidChange(_ result: [JournalEntry]) {
        updatedEntries = result
        expectations.first?.fulfill()
        if !expectations.isEmpty {
            expectations.removeFirst()
        }
    }

    // MARK: - Journal Entry Test Cases

    func testCreateEmptyJournalEntry() {
        let entry0 = dataService.createJournalEntry()
        XCTAssertNotNil(entry0, "entry0 should not be nil")
        XCTAssertNotNil(entry0.id, "entry0.id should not be nil")
        XCTAssertNotNil(entry0.startDate)
        XCTAssertNotNil(entry0.finishDate)
        XCTAssertEqual(entry0.journalType, .none)
        XCTAssertTrue(entry0.worksTitle == "")
        XCTAssertTrue(entry0.entryTitle == "")
        XCTAssertTrue(entry0.entryContent == "")
        XCTAssertTrue(entry0.quote == "")
        XCTAssertTrue(entry0.longitude == 0)
        XCTAssertTrue(entry0.latitude == 0)
        // swiftformat:disable:next isEmpty
        XCTAssertTrue(entry0.tags?.count == 0)
        XCTAssertTrue(entry0.rating == 0)
        XCTAssertTrue(entry0.favorite == false)
    }

    func testCreateJournalEntryWithValue() {
        let date1 = Date(timeIntervalSince1970: 10080)
        let date2 = Date(timeIntervalSince1970: 10080)
        let tag1 = dataService.createNewTag("Badass")
        let tag2 = dataService.createNewTag("Superhero")
        let image1 = UIImage(named: "TestImage1")
        XCTAssertNotNil(image1)
        let entry1 = dataService.createJournalEntry(aboutWork: "Batman",
                                                    withType: .movie,
                                                    withCoverImage: image1,
                                                    withStartDate: date1,
                                                    withFinishDate: date2,
                                                    withEntryTitle: "Okay that's cool",
                                                    withEntryContent: "Very very cool",
                                                    withQuote: "This is a quote from the movie",
                                                    atLongitude: 1.11,
                                                    atLatitude: -2.22,
                                                    withTags: [tag1, tag2],
                                                    withRating: 3,
                                                    isFavorite: true)
        XCTAssertNotNil(entry1, "entry1 should not be nil")
        XCTAssertNotNil(entry1.id, "entry1.id should not be nil")
        XCTAssertTrue(entry1.worksTitle == "Batman")
        XCTAssertEqual(entry1.journalType, .movie)
        XCTAssertNotNil(entry1.image)
        XCTAssertTrue(entry1.startDate == date1)
        XCTAssertTrue(entry1.finishDate == date2)
        XCTAssertTrue(entry1.entryTitle == "Okay that's cool")
        XCTAssertTrue(entry1.entryContent == "Very very cool")
        XCTAssertTrue(entry1.quote == "This is a quote from the movie")
        XCTAssertTrue(entry1.longitude == 1.11)
        XCTAssertTrue(entry1.latitude == -2.22)
        XCTAssertTrue(entry1.tags == NSSet(array: [tag1, tag2]))
        XCTAssertTrue(entry1.rating == 3)
        XCTAssertTrue(entry1.favorite == true)
    }

    func testUpdateJournalEntry() {
        let entry0 = dataService.createJournalEntry()
        XCTAssertNotNil(entry0, "entry0 should not be nil")
        XCTAssertNotNil(entry0.id, "entry0.id should not be nil")
        XCTAssertNil(entry0.image)

        let date1 = Date(timeIntervalSince1970: 10080)
        let date2 = Date(timeIntervalSince1970: 10020)
        let tag1 = dataService.createNewTag("Sci-Fi")
        let tag2 = dataService.createNewTag("Starts")
        let image1 = UIImage(named: "TestImage1")
        let image2 = UIImage(named: "TestImage2")
        XCTAssertNotNil(image1)
        XCTAssertNotNil(image2)
        let result1 = dataService.updateJournalEntry(withUUID: entry0.id!,
                                                     aboutWork: "Interstellar",
                                                     withType: .movie,
                                                     withCoverImage: image1,
                                                     withStartDate: date1,
                                                     withFinishDate: date2,
                                                     withEntryTitle: "Impressive",
                                                     withEntryContent: "I don't know what to say",
                                                     withQuote: "This is another quote from the movie",
                                                     atLongitude: 3.14,
                                                     atLatitude: -6.28,
                                                     withTags: [tag1, tag2],
                                                     withRating: 7,
                                                     isFavorite: true)
        switch result1 {
        case let .failure(error):
            XCTFail(error.localizedDescription)
        default: break
        }
        XCTAssertTrue(entry0.worksTitle == "Interstellar")
        XCTAssertEqual(entry0.journalType, .movie)
        XCTAssertNotNil(entry0.image)
        XCTAssertTrue(entry0.startDate == date1)
        XCTAssertTrue(entry0.finishDate == date2)
        XCTAssertTrue(entry0.entryTitle == "Impressive")
        XCTAssertTrue(entry0.entryContent == "I don't know what to say")
        XCTAssertTrue(entry0.quote == "This is another quote from the movie")
        XCTAssertTrue(entry0.longitude == 3.14)
        XCTAssertTrue(entry0.latitude == -6.28)
        XCTAssertTrue(entry0.tags == NSSet(array: [tag1, tag2]))
        XCTAssertTrue(entry0.rating == 0)
        XCTAssertTrue(entry0.favorite == true)
        let fetchedEntry0 = dataService.fetchJournalEntryWithUUID(entry0.id!)
        XCTAssertNotNil(fetchedEntry0)
        XCTAssertTrue(fetchedEntry0?.worksTitle == "Interstellar")
        XCTAssertEqual(fetchedEntry0?.journalType, .movie)
        XCTAssertNotNil(fetchedEntry0?.image)
        XCTAssertTrue(fetchedEntry0?.startDate == date1)
        XCTAssertTrue(fetchedEntry0?.finishDate == date2)
        XCTAssertTrue(fetchedEntry0?.entryTitle == "Impressive")
        XCTAssertTrue(fetchedEntry0?.entryContent == "I don't know what to say")
        XCTAssertTrue(fetchedEntry0?.quote == "This is another quote from the movie")
        XCTAssertTrue(fetchedEntry0?.longitude == 3.14)
        XCTAssertTrue(fetchedEntry0?.latitude == -6.28)
        XCTAssertTrue(fetchedEntry0?.tags == NSSet(array: [tag1, tag2]))
        XCTAssertTrue(fetchedEntry0?.rating == 0)
        XCTAssertTrue(fetchedEntry0?.favorite == true)
    }

    func testUpdateJournalEntryWithoutUUID() {
        let result = dataService.updateJournalEntry(withUUID: nil,
                                                    aboutWork: "Interstellar",
                                                    withType: .movie,
                                                    withEntryTitle: "Impressive",
                                                    withEntryContent: "I don't know what to say",
                                                    withQuote: "This is another quote from the movie",
                                                    atLongitude: 3.14,
                                                    atLatitude: -6.28,
                                                    withTags: [],
                                                    withRating: 7,
                                                    isFavorite: true)
        switch result {
        case let .failure(error):
            XCTFail(error.localizedDescription)
        default: break
        }
    }

    func testDeleteJournalEntry() {
        let entry0 = dataService.createJournalEntry()
        XCTAssertNotNil(entry0, "entry0 should not be nil before deletion")
        XCTAssertNotNil(entry0.id, "entry0.id should not be nil before deletion")

        XCTAssertTrue(dataService.deleteJournalEntry(withUUID: entry0.id!))
        let result0 = dataService.fetchAllJournalEntries()
        XCTAssertTrue(result0?.isEmpty == true, "There should be no entry after entry0 is deleted")

        let date1 = Date(timeIntervalSince1970: 10080)
        let date2 = Date(timeIntervalSince1970: 10080)
        let tag1 = dataService.createNewTag("good")
        let tag2 = dataService.createNewTag("good2")
        let entry1 = dataService.createJournalEntry(aboutWork: "Batman",
                                                    withStartDate: date1,
                                                    withFinishDate: date2,
                                                    withEntryTitle: "Okay that's cool",
                                                    withEntryContent: "Very very cool",
                                                    withQuote: "ccccc",
                                                    atLongitude: 1.11,
                                                    atLatitude: -2.22,
                                                    withTags: [tag1, tag2],
                                                    isFavorite: true)
        XCTAssertNotNil(entry1, "entry1 should not be nil before deletion")
        XCTAssertNotNil(entry1.id, "entry1.id should not be nil before deletion")

        XCTAssertTrue(dataService.deleteJournalEntry(withUUID: entry1.id!))
        let result1 = dataService.fetchAllJournalEntries()
        XCTAssertTrue(result1?.isEmpty == true, "There should be no entry after entry1 is deleted")
    }

    func testFetchAllJournalEntriesWithDefaultSort() {
        let date0 = Date(timeIntervalSince1970: 10080)
        _ = dataService.createJournalEntry(withType: .book, withFinishDate: date0)

        let date1 = Date(timeIntervalSince1970: 10060)
        _ = dataService.createJournalEntry(withType: .movie, withFinishDate: date1)

        let date2 = Date(timeIntervalSince1970: 10090)
        _ = dataService.createJournalEntry(withType: .game, withFinishDate: date2)

        let allEntries = dataService.fetchAllJournalEntries()
        if let entries = allEntries {
            XCTAssertEqual(entries.count, 3)
            var carryDate = Date(timeIntervalSince1970: 20000)
            for entry in entries {
                let entryDate = entry.finishDate
                XCTAssertNotNil(entryDate)
                XCTAssertGreaterThanOrEqual(carryDate, entryDate!)
                carryDate = entryDate!
            }
        } else { XCTFail("query result should not be nil") }

        let gameEntries = dataService.fetchAllJournalEntries(withType: .game)
        if let entries = gameEntries {
            XCTAssertFalse(entries.isEmpty)
            for entry in entries {
                XCTAssertEqual(entry.journalType, .game)
            }
        } else { XCTFail("query result should not be nil") }
    }

    func testFetchJournalEntryWithUUID() {
        let entry0 = dataService.createJournalEntry()
        let fetchedEntry0 = dataService.fetchJournalEntryWithUUID(entry0.id!)
        XCTAssertTrue(entry0 == fetchedEntry0)

        let date1 = Date(timeIntervalSince1970: 10080)
        let date2 = Date(timeIntervalSince1970: 10080)
        let tag1 = dataService.createNewTag("Badass")
        let tag2 = dataService.createNewTag("Superhero")
        let image1 = UIImage(named: "TestImage1")
        let image2 = UIImage(named: "TestImage2")
        XCTAssertNotNil(image1)
        XCTAssertNotNil(image2)
        let entry1 = dataService.createJournalEntry(aboutWork: "Batman",
                                                    withCoverImage: image1,
                                                    withStartDate: date1,
                                                    withFinishDate: date2,
                                                    withEntryTitle: "Okay that's cool",
                                                    withEntryContent: "Very very cool",
                                                    atLongitude: 1.11,
                                                    atLatitude: -2.22,
                                                    withTags: [tag1, tag2],
                                                    isFavorite: true)
        XCTAssertNotNil(entry1, "entry1 should not be nil")
        XCTAssertNotNil(entry1.id, "entry1.id should not be nil")
        let date3 = Date(timeIntervalSince1970: 20060)
        let tag3 = dataService.createNewTag("NVM")
        let result = dataService.updateJournalEntry(withUUID: entry1.id!,
                                                    aboutWork: "Hitman",
                                                    withCoverImage: image2,
                                                    withStartDate: date1,
                                                    withFinishDate: date3,
                                                    withEntryTitle: "Not bad",
                                                    withEntryContent: "Just okay",
                                                    atLongitude: -6.7,
                                                    atLatitude: 239_432,
                                                    withTags: [tag1, tag3],
                                                    isFavorite: false)
        switch result {
        case let .failure(error):
            XCTFail(error.localizedDescription)
        default: break
        }
        let fetchedEntry1 = dataService.fetchJournalEntryWithUUID(entry1.id!)
        XCTAssertTrue(entry1 == fetchedEntry1)
    }

    func testCrossDataServiceAccess() {
        XCTAssertFalse(dataService === secondDataService)

        let entry0 = dataService.createJournalEntry()
        XCTAssertNotNil(entry0)
        XCTAssertEqual(secondDataService.fetchAllJournalEntries()?.count, 1)
        XCTAssertNotNil(entry0.id)
        XCTAssertNil(entry0.image)

        let date1 = Date(timeIntervalSince1970: 10080)
        let date2 = Date(timeIntervalSince1970: 10020)
        let tag1 = dataService.createNewTag("Sci-Fi")
        let tag2 = dataService.createNewTag("Starts")
        let image1 = UIImage(named: "TestImage1")
        let image2 = UIImage(named: "TestImage2")
        XCTAssertNotNil(image1)
        XCTAssertNotNil(image2)

        let result = dataService.updateJournalEntry(withUUID: entry0.id!,
                                                    aboutWork: "Interstellar",
                                                    withType: .movie,
                                                    withCoverImage: image1,
                                                    withStartDate: date1,
                                                    withFinishDate: date2,
                                                    withEntryTitle: "Impressive",
                                                    withEntryContent: "I don't know what to say",
                                                    withQuote: "This is another quote from the movie",
                                                    atLongitude: 3.14,
                                                    atLatitude: -6.28,
                                                    withTags: [tag1, tag2],
                                                    withRating: 7,
                                                    isFavorite: true)
        switch result {
        case let .failure(error):
            XCTFail(error.localizedDescription)
        default: break
        }
        XCTAssertTrue(entry0.worksTitle == "Interstellar")
        XCTAssertEqual(entry0.journalType, .movie)
        XCTAssertNotNil(entry0.image)
        XCTAssertTrue(entry0.startDate == date1)
        XCTAssertTrue(entry0.finishDate == date2)
        XCTAssertTrue(entry0.entryTitle == "Impressive")
        XCTAssertTrue(entry0.entryContent == "I don't know what to say")
        XCTAssertTrue(entry0.quote == "This is another quote from the movie")
        XCTAssertTrue(entry0.longitude == 3.14)
        XCTAssertTrue(entry0.latitude == -6.28)
        XCTAssertTrue(entry0.tags == NSSet(array: [tag1, tag2]))
        XCTAssertTrue(entry0.rating == 0)
        XCTAssertTrue(entry0.favorite == true)
        let fetchedEntry0 = secondDataService.fetchJournalEntryWithUUID(entry0.id!)
        XCTAssertNotNil(fetchedEntry0)
        XCTAssertTrue(fetchedEntry0?.worksTitle == "Interstellar")
        XCTAssertEqual(fetchedEntry0?.journalType, .movie)
        XCTAssertNotNil(fetchedEntry0?.image)
        XCTAssertTrue(fetchedEntry0?.startDate == date1)
        XCTAssertTrue(fetchedEntry0?.finishDate == date2)
        XCTAssertTrue(fetchedEntry0?.entryTitle == "Impressive")
        XCTAssertTrue(fetchedEntry0?.entryContent == "I don't know what to say")
        XCTAssertTrue(fetchedEntry0?.quote == "This is another quote from the movie")
        XCTAssertTrue(fetchedEntry0?.longitude == 3.14)
        XCTAssertTrue(fetchedEntry0?.latitude == -6.28)
        XCTAssertTrue(fetchedEntry0?.tags == NSSet(array: [tag1, tag2]))
        XCTAssertTrue(fetchedEntry0?.rating == 0)
        XCTAssertTrue(fetchedEntry0?.favorite == true)

        let entry1 = secondDataService.createJournalEntry()
        XCTAssertNotNil(entry1)
        XCTAssertEqual(dataService.fetchAllJournalEntries()?.count, 2)
    }

    func testJournalEntryBackgroundUpdate() {

        dataService.delegate = self
        dataService.createJournalEntry(withEntryTitle: "entry1")

        _ = dataService.fetchAllJournalEntries()

        expectations.append(expectation(description: "Expect call back for new jouranl entries"))
        secondDataService.createJournalEntry(withEntryTitle: "entry2")

        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertEqual(updatedEntries.count, 2)
    }
}
