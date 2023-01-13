//
//  ExtensionDCContainerTableview.swift
//  VENI VIDI
//
//  Created by 马晓雯 on 4/5/21.
//

import DCFrame
import Foundation
import UIKit

extension DCContainerTableView {
    func tableView(_: UITableView, canEditRowAt _: IndexPath) -> Bool {
        true
    }

    func tableView(_: UITableView, commit _: UITableViewCell.EditingStyle, forRowAt _: IndexPath) {
        print("Swiping")
    }
}
