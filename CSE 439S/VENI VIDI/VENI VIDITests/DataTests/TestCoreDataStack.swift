//
//  TestCoreDataStack.swift
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
import CoreData
import Foundation

class TestCoreDataStack: CoreDataStack {
    override init() {
        super.init()

        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType

        let container = NSPersistentContainer(name: "VENI_VIDI")
        container.persistentStoreDescriptions = [persistentStoreDescription]

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        storeContainer = container
        mainContext = storeContainer.viewContext
    }
}
