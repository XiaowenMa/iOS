//
//  CoreDataTest.swift
//  VENI VIDITests
//
//  Created by 雲無心 on 3/13/21.
//
//  Tutorial copywrite info below
//

// Copyright (c) 2020 Razeware LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

@testable import VENI_VIDI
import UIKit
import XCTest

class DataServiceTests: XCTestCase {
    // MARK: - Properties and Set Up

    var coreDataStack: CoreDataStack!
    var dataService: DataService!
    var secondDataService: DataService!
    var updatedEntries: [JournalEntry] = []
    var expectations: [XCTestExpectation] = []

    override func setUp() {
        super.setUp()
        coreDataStack = TestCoreDataStack()
        dataService = DataService(coreDataStack: coreDataStack)
        secondDataService = DataService(coreDataStack: coreDataStack)
    }

    override func tearDown() {
        coreDataStack = nil
        dataService = nil
        secondDataService = nil
        super.tearDown()
    }
}
