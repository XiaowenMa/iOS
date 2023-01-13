//
//  ShelfCellModel.swift
//  VENI VIDI
//
//  Created by MonAster on 2021/4/26.
//

import DCFrame

class ShelfCellModel: DCCellModel {

    var title = "Shelf"
    var entries: [JournalEntry]?

    required init() {
        super.init()
        cellClass = ShelfCell.self
        guard var count = entries?.count else { return }
        count /= 3 + 1
        cellHeight = CGFloat(50 + 250 * count)
    }

    func resize(height: CGFloat) {
        cellHeight = height
    }

    func set(withType type: JournalEntryType, withEntries entries: [JournalEntry]) {
        switch type {
        case .book:
            title = "Books"
        case .movie:
            title = "Movies"
        case .tvShow:
            title = "TV Shows"
        case .game:
            title = "Games"
        default:
            title = "Recommendations"
        }
        self.entries = entries
    }
}
