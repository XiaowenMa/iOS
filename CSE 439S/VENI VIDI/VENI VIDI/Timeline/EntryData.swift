//
//  EntryData.swift
//  VENI VIDI
//
//  Created by 马晓雯 on 2/26/21.
//

import Foundation
import UIKit

struct EntryData: Decodable {
    var title: String = ""
    var url: String = ""
    var date: Date?
    var rate: Double?
    var comment: String = ""
    var type: String?

    init() {}

    init(withTitle title: String, image cover: String, asType type: JournalEntryType) {
        self.title = title
        url = cover
        self.type = type.rawValue
    }
}
