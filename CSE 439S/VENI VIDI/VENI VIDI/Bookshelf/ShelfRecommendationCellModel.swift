//
//  ShelfRecommendationCellModel.swift
//  VENI VIDI
//
//  Created by MonAster on 2021/5/3.
//

import DCFrame

class ShelfRecommendationCellModel: DCCellModel {

    var title = "Shelf"
    var entries: [QueryResult]?

    required init() {
        super.init()
        cellClass = ShelfRecommendationCell.self
        guard var count = entries?.count else { return }
        count /= 3 + 1
        cellHeight = CGFloat(50 + 250 * count)
    }

    func resize(height: CGFloat) {
        cellHeight = height
    }

    func set(withType type: JournalEntryType, withEntries entries: [QueryResult]) {
        switch type {
        case .movie:
            title = "Recommended Movies"
        case .tvShow:
            title = "Recommended TV Shows"
        default:
            title = "Recommendations"
        }
        self.entries = entries
    }
}
