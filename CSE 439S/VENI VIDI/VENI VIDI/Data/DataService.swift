//
//  EntryService.swift
//  VENI VIDI
//
//  Created by 雲無心 on 3/13/21.
//

import CoreData
import Foundation
import UIKit

// MARK: - DataService

final class DataService: NSObject, NSFetchedResultsControllerDelegate {
    // MARK: - Properties

    private let managedObjectContext: NSManagedObjectContext
    private let coreDataStack: CoreDataStack
    private var fetchedResultsController: NSFetchedResultsController<JournalEntry>?
    weak var delegate: DataServiceDelegate?

    // MARK: - Initializers

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        managedObjectContext = self.coreDataStack.mainContext
    }
}

// MARK: - Tag Related Services

extension DataService {

    func fetchAllTags() -> [Tag] {
        do {
            let fetchRequest = NSFetchRequest<Tag>(entityName: "Tag")
            let tags = try managedObjectContext.fetch(fetchRequest)
            return tags
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    func addTag(_ tag: Tag, toJournalEntry journalEntry: JournalEntry) {
        journalEntry.addToTags(tag)
    }

    func addTags(_ tags: [Tag], toJournalEntry journalEntry: JournalEntry) {
        journalEntry.addToTags(NSSet(array: tags))
    }

    func removeTag(_ tag: Tag, fromJournalEntry journalEntry: JournalEntry) {
        journalEntry.removeFromTags(tag)
    }

    func removeTags(_ tags: [Tag], fromJournalEntry journalEntry: JournalEntry) {
        journalEntry.removeFromTags(NSSet(array: tags))
    }

    func createNewTag(_ tagText: String) -> Tag {
        guard let newTag = NSEntityDescription.insertNewObject(forEntityName: "Tag", into: managedObjectContext) as? Tag else { return Tag() }

        newTag.name = tagText
        newTag.id = UUID()
        coreDataStack.saveContext()
        return newTag
    }

    func renameTagWithUUID(_ id: UUID, withNewName newName: String) -> Tag? {
        guard let tag = fetchTagWithUUID(id) else { return nil }
        tag.name = newName
        coreDataStack.saveContext()
        return tag
    }

    func fetchTagWithUUID(_ id: UUID) -> Tag? {
        do {
            let fetchRequest = NSFetchRequest<Tag>(entityName: "Tag")
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            let tag = try managedObjectContext.fetch(fetchRequest)[0]
            return tag
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    func deleteTagWithUUID(_ id: UUID) -> Bool {
        guard let tag = fetchTagWithUUID(id) else {
            print("Received invalid UUID for deleteTag()")
            return false
        }

        managedObjectContext.delete(tag)
        coreDataStack.saveContext()
        return true
    }
}

// MARK: - Journal Entry Services

extension DataService {
    /// This function fetches all journal entries that are in the CoreData data storage.
    /// - Returns: All available journal entries.
    /// - Parameter category: the type of JournalEntry to query for
    func fetchAllJournalEntries(withType type: JournalEntryType? = nil) -> [JournalEntry]? {

        let fetchRequest = NSFetchRequest<JournalEntry>(entityName: "JournalEntry")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "finishDate", ascending: false)]
        if let targetType = type {
            fetchRequest.predicate = NSPredicate(format: "journalTypeText = %@", targetType.rawValue)
        }

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController?.delegate = self

        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error.localizedDescription)
            return nil
        }
        return fetchedResultsController?.fetchedObjects
    }

    /// Fetch for a specific JournalEntry given its id (UUID).
    /// - Parameter id: The UUID that belongs to and identifies the target JournalEntry.
    /// - Returns: The JournalEntry with the given id (UUID),
    ///            nil if there's an error when fetching from CoreData data storage.
    func fetchJournalEntryWithUUID(_ id: UUID) -> JournalEntry? {
        do {
            let fetchRequest = NSFetchRequest<JournalEntry>(entityName: "JournalEntry")
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            let entry = try managedObjectContext.fetch(fetchRequest)[0]
            return entry
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    /// Create a new JournalEntry with given values. Values not provided will default to nil, empty string, or 0.
    /// - Parameters:
    ///   - work: Name of the work to be recorded in this entry.
    ///   - type: Type of the work. Default to .none.
    ///   - coverImage: Cover image to be used for this entry.
    ///   - startDate: Default to Date().
    ///   - finishDate: Default to Date().
    ///   - entryTitle: Title of this JournalEntry.
    ///   - entryContent: Text content of this JournalEntry.
    ///   - quote: A single line quote for this JournalEntry.
    ///   - longitude: Longitude value for entry location. Only used when both longitude and latitude are provided.
    ///   - latitude: Latitude value for entry location. Only used when both longitude and latitude are provided.
    ///   - tags: Tagges that should be assgined to this JournalEntry.
    ///   - rating: User rating.
    ///   - favorite: User favorite or not.
    /// - Returns: The created JournalEntry.
    @discardableResult
    func createJournalEntry(aboutWork work: String = "",
                            withType type: JournalEntryType = .none,
                            withCoverImage coverImage: UIImage? = nil,
                            withStartDate startDate: Date = Date(),
                            withFinishDate finishDate: Date = Date(),
                            withEntryTitle entryTitle: String = "",
                            withEntryContent entryContent: String = "",
                            withQuote quote: String = "",
                            atLongitude longitude: Double = 0,
                            atLatitude latitude: Double = 0,
                            withTags tags: [Tag] = [],
                            withRating rating: Double = 0,
                            isFavorite favorite: Bool? = false) -> JournalEntry {

        let newJournalEntry = NSEntityDescription.insertNewObject(forEntityName: "JournalEntry", into: managedObjectContext) as! JournalEntry
        newJournalEntry.id = UUID()
        coreDataStack.saveContext()

        let result = updateJournalEntry(withUUID: newJournalEntry.id,
                                        aboutWork: work,
                                        withType: type,
                                        withCoverImage: coverImage,
                                        withStartDate: startDate,
                                        withFinishDate: finishDate,
                                        withEntryTitle: entryTitle,
                                        withEntryContent: entryContent,
                                        withQuote: quote,
                                        atLongitude: longitude,
                                        atLatitude: latitude,
                                        withTags: tags,
                                        withRating: rating,
                                        isFavorite: favorite)
        switch result {
        case let .success(journalEntry):
            return journalEntry
        case let .failure(error):
            print(error.localizedDescription)
            return newJournalEntry
        }
    }

    /// Update the attributes of a JournalEntry, identified by its id (UUID).
    /// If no id is provided, a new JournalEntry is created to carry the values.
    /// If an attribute is not provided, it will not be updated.
    /// - Parameters:
    ///   - id: The UUID used for looking up the JournalEntry.
    ///         A new entry will be created if this field is not provided.
    ///   - work: New name of the work to be recorded in this entry.
    ///   - type: New type of the work.
    ///   - coverImage: New cover image to be used for this entry.
    ///   - startDate: New start date to be used for this entry.
    ///   - finishDate: New finish date to be used for this entry.
    ///   - entryTitle: New title of this JournalEntry.
    ///   - entryContent: New text content of this JournalEntry.
    ///   - quote: New quote for this JournalEntry.
    ///   - longitude: New longitude value for entry location. Only used when both longitude and latitude are provided.
    ///   - latitude: New latitude value for entry location. Only used when both longitude and latitude are provided.
    ///   - tags: New set of tagges that should be assgined to this JournalEntry.
    ///           Tagges not in this set will be removed from this entry.
    ///   - rating: New user rating.
    ///   - favorite: User favorite or not.
    /// - Returns: A Result object that contains either the updated JournalEntry or an error value.
    @discardableResult
    func updateJournalEntry(withUUID id: UUID? = nil,
                            aboutWork work: String? = nil,
                            withType type: JournalEntryType? = nil,
                            withCoverImage coverImage: UIImage? = nil,
                            withStartDate startDate: Date? = nil,
                            withFinishDate finishDate: Date? = nil,
                            withEntryTitle entryTitle: String? = nil,
                            withEntryContent entryContent: String? = nil,
                            withQuote quote: String? = nil,
                            atLongitude longitude: Double? = nil,
                            atLatitude latitude: Double? = nil,
                            withTags tags: [Tag]? = nil,
                            withRating rating: Double? = nil,
                            isFavorite favorite: Bool? = nil) -> Result<JournalEntry, DataServiceError> {

        let entry: JournalEntry

        if let entryId = id {
            guard let fetchedEntry = fetchJournalEntryWithUUID(entryId) else { return .failure(.invalidUUID) }
            entry = fetchedEntry
        } else {
            entry = createJournalEntry()
        }

        entry.lastEditDate = Date()
        entry.worksTitle = work ?? entry.worksTitle
        entry.journalType = type ?? entry.journalType
        entry.startDate = startDate ?? entry.startDate
        entry.finishDate = finishDate ?? entry.finishDate
        entry.entryTitle = entryTitle ?? entry.entryTitle
        entry.entryContent = entryContent ?? entry.entryContent
        entry.quote = quote ?? entry.quote
        entry.favorite = favorite ?? entry.favorite

        if let newLongitude = longitude {
            if let newLatitude = latitude {
                entry.longitude = newLongitude
                entry.latitude = newLatitude
            } else {
                print("Entry location not updated. Both longitude and latitude needed for update.")
            }
        }

        if let newTags = tags {
            let oldTags = entry.tags
            entry.removeFromTags(oldTags ?? NSSet())
            entry.addToTags(NSSet(array: newTags))
        }

        if let newImage = coverImage {
            // https://stackoverflow.com/questions/16685812/how-to-store-an-image-in-core-data#16687218
            if let imageData = newImage.pngData() {
                entry.image = imageData
            } else {
                print("Failed to store image in CoreData")
            }
        }

        if let newRating = rating {
            if newRating >= 0, newRating <= 5 {
                entry.rating = newRating
            } else {
                print("Received invalid rating value \(newRating)")
            }
        }

        coreDataStack.saveContext()
        return .success(entry)
    }

    /// Delete a JournalEntry given its id (UUID).
    /// - Parameter id: UUID of the JournalEntry that should be deleted.
    /// - Returns: True if the entry is deleted, false if the id (UUID) does not match any existing entry.
    @discardableResult
    func deleteJournalEntry(withUUID id: UUID) -> Bool {
        guard let entry = fetchJournalEntryWithUUID(id) else {
            print("Received invalid UUID for deleteJournalEntry()")
            return false
        }

        managedObjectContext.delete(entry)
        coreDataStack.saveContext()
        return true
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension DataService {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let updatedJournalEntries = controller.fetchedObjects as? [JournalEntry] {
            delegate?.fetchAllJournalEntriesResultDidChange(updatedJournalEntries)
        } else {
            print("Error: NSFetchedResultsController has a NSFetchRequestResult type different from JournalEntry.")
        }
    }
}
