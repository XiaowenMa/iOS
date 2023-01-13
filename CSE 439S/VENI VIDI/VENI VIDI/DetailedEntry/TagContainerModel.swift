//
//  TagContainerModel.swift
//  VENI VIDI
//
//  Created by 马晓雯 on 4/18/21.
//

import DCFrame
import Foundation
import UIKit

class TagContainerModel: DCContainerModel {

    var entryId: UUID?
    var tags: [String] = []

    override func cmDidLoad() {
        super.cmDidLoad()

        let tagCellModel = TagCellModel()
        tagCellModel.tags = tags

        addSubmodel(tagCellModel)
    }
}
