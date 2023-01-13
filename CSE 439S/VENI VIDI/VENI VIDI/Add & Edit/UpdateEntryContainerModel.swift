//
//  UpdateEntryContainerModel.swift
//  VENI VIDI
//
//  Created by 马晓雯 on 3/8/21.
//

import DCFrame
import Foundation
import UIKit

class UpdateEntryContainerModel: VVContainerModel {
    var entryTitle: String? // should be passed by last TimelineViewController
    var poster: UIImage?
    var comment: String?
    var stars: Double?
    var date: Date?
    var nav: UINavigationController?
    var quote: String?
    var favorite: Bool?
    var type: JournalEntryType?
    var tags: [String] = []

    var entryId: UUID?

    let searchCM = SearchCM()
    let newEntryModel = UpdateEntryCellModel()

    override func cmDidLoad() {
        super.cmDidLoad()

        containerTableView?.contentInset = UIEdgeInsets(top: 150, left: 0, bottom: 100, right: 0)

        newEntryModel.nav = nav
        newEntryModel.service = dataService

        if let title = entryTitle {
            newEntryModel.entryTitle = title
        } else {
            // throw error
        }

        if let image = poster {
            newEntryModel.posterImage = image
        }

        if let rating = stars {
            newEntryModel.rating = rating
        }

        if let commentContent = comment {
            newEntryModel.comment = commentContent
        }

        if let id = entryId {
            newEntryModel.entryId = id
        }

        if let quote = quote {
            newEntryModel.quote = quote
        }

        if let favorite = favorite {
            newEntryModel.favorite = favorite
        }

        newEntryModel.tags = tags

        addSubmodel(searchCM)
        addSubmodel(newEntryModel)
    }
}
