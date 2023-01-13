//
//  FloatLabel.swift
//  VENI VIDI
//
//  Created by 马晓雯 on 4/9/21.
//

import Foundation
import UIKit

class FloatLabelView: UIView {
    var entryID: UUID?

    var label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.frame = self.frame
        label.textColor = .black
        addSubview(label)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        label.frame = frame
        label.textColor = .black
        addSubview(label)
    }
}
