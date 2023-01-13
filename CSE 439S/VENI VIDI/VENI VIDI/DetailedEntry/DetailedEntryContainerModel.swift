//
//  DetailedEntryContainerModel.swift
//  VENI VIDI
//
//  Created by 马晓雯 on 2/26/21.
//

import DCFrame
import Foundation
import UIKit

class DetailedEntryContainerModel: DCContainerModel {
    var entryTitle: String? // should be passed by last TimelineViewController
    var poster: UIImage?
    var comment: String?
    var stars: Double?
    var date: Date?
    var quote: String?
    var favorite: Bool?
    var entryId: UUID?
    var nav: UINavigationController?

    var tags: [String] = []

    override func tableViewDataWillReload() {
        removeAllSubmodels()

        let detailModel = DetailedEntryCellModel()
        detailModel.nav = nav
        if let title = entryTitle {
            detailModel.entryTitle = title
        }

        if let image = poster {
            detailModel.posterImage = image
        }

        if let rating = stars {
            detailModel.rating = rating
        }

        if let commentContent = comment {
            detailModel.comment = commentContent
        }

        if let date = date {
            detailModel.date = date
        }

        if let quote = quote {
            detailModel.quote = quote
        }

        if let fav = favorite {
            detailModel.favorite = fav
        }

        if let entryId = entryId {
            detailModel.id = entryId
        }

        detailModel.tags = tags

        addSubmodel(detailModel)
    }

    override func cmDidLoad() {
        super.cmDidLoad()

        containerTableView?.contentInset = UIEdgeInsets(top: 150, left: 0, bottom: 0, right: 0)
        let detailModel = DetailedEntryCellModel()
        detailModel.nav = nav
        if let title = entryTitle {
            detailModel.entryTitle = title
        }

        if let image = poster {
            detailModel.posterImage = image
        }

        if let rating = stars {
            detailModel.rating = rating
        }

        if let commentContent = comment {
            detailModel.comment = commentContent
        }

        if let quote = quote {
            detailModel.quote = quote
        }

        if let fav = favorite {
            detailModel.favorite = fav
        }

        if let entryId = entryId {
            detailModel.id = entryId
        }

        detailModel.tags = tags

        addSubmodel(detailModel)
    }
}
