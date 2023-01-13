//
//  CoreDataStack.swift
//  VENI VIDI
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

import CoreData
import Foundation
import UIKit

class CoreDataStack: NSObject {

    public lazy var storeContainer: NSPersistentContainer = {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }()

    public lazy var mainContext: NSManagedObjectContext = {
        storeContainer.viewContext.automaticallyMergesChangesFromParent = true
        return storeContainer.viewContext
    }()

    public func saveContext() {
        mainContext.perform {
            do {
                try self.mainContext.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
