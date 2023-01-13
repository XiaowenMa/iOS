//
//  TimelinePickerCell.swift
//  VENI VIDI
//
//  Created by MonAster on 2021/4/19.
//

import DCFrame
import Foundation
import SnapKit
import UIKit

class TimelinePickerCell: DCBaseCell {
    static let timelineTypeChanged = DCEventID()
    private var timelineType = "book"

    private let segments: [(String, String)] = [("All", "all"),
                                                ("Books", "book"),
                                                ("Movies", "movie"),
                                                ("TV Shows", "tvShow")]

    private lazy var timelinePicker: UISegmentedControl = {
        let timelinePicker = UISegmentedControl(items: segments.map(\.0))
        timelinePicker.selectedSegmentIndex = 0
        timelinePicker.addTarget(self, action: #selector(TimelinePickerCell.changeTimelineType(_:)), for: .valueChanged)
        contentView.addSubview(timelinePicker)
        return timelinePicker
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        timelinePicker.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
    }

    @objc
    func changeTimelineType(_ control: UISegmentedControl) {
        sendEvent(Self.timelineTypeChanged, data: segments[control.selectedSegmentIndex].1)
    }
}
