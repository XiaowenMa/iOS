//
//  TagCellModel.swift
//  VENI VIDI
//
//  Created by 马晓雯 on 4/18/21.
//

import DCFrame
import Foundation
import UIKit
class TagCellModel: DCCellModel {

    var id: UUID?
    var tags: [String] = []

    required init() {
        super.init()
        cellHeight = 75
        cellClass = TagCell.self
    }
}
