//
//  TimeLabelCell.swift
//  VENI VIDI
//
//  Created by 马晓雯 on 2/26/21.
//

import DCFrame
import Foundation
import SnapKit
import UIKit

class TimeLabelCell: DCCell<TimeLabelCellModel> {
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.backgroundColor = UIColor.systemYellow
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 6
        label.textColor = .systemGray
        return label
    }()

    override func setupUI() {
        super.setupUI()

        contentView.addSubview(label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = contentView.bounds
        let left: CGFloat = 15
        print(bounds.height)

        label.frame = CGRect(x: left, y: bounds.height - 45, width: bounds.width - 30, height: 40)
    }

    override func cellModelDidUpdate() {
        super.cellModelDidUpdate()
        label.text = " " + cellModel.timeLabel
    }
}
