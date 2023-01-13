//
//  FloatingLabel.swift
//  VENI VIDI
//
//  Created by 马晓雯 on 4/9/21.
//

import Foundation
import UIKit
class FloatLabel: UILabel {
    var id: UUID?
    override init(frame theFrame: CGRect) {
        super.init(frame: theFrame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
