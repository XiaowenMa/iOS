//
//  UpdateEntryCellModel.swift
//  VENI VIDI
//
//  Created by 马晓雯 on 3/9/21.
//

import DCFrame
import Foundation
import UIKit

class UpdateEntryCellModel: DCCellModel {
    var entryTitle: String = ""
    var comment: String = ""
    var rating: Double?
    var posterImage = UIImage(named: "logo_background")!
    var date: Date?
    var quote: String = ""
    var favorite: Bool = false
    var nav: UINavigationController?
    var type: JournalEntryType = .book
    var service: DataService = {
        let service = DataService(coreDataStack: CoreDataStack())
        return service
    }()

    var entryId: UUID?
    var tags: [String] = []

    required init() {
        super.init()
        cellHeight = 800
        cellClass = UpdateEntryCell.self
    }
}
