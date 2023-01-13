//
//  VENI_VIDIContainerModel.swift
//  VENI VIDI
//
//  Created by 马晓雯 on 3/16/21.
//

import DCFrame
import Foundation
import UIKit

class VVContainerModel: DCContainerModel {
    public let dataService = DataService(coreDataStack: CoreDataStack())

    override func cmDidLoad() {
        super.cmDidLoad()
    }
}
