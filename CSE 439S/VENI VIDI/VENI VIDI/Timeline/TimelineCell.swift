//
//  TimelineCell.swift
//  VENI VIDI
//
//  Created by 马晓雯 on 2/26/21.
//

import Cosmos
import DCFrame
import Foundation
import SnapKit
import UIKit

class TimelineCell: DCCell<TimelineCellModel> {
    static let touch = DCEventID()
    // Outlets
    let starsCosmosView: CosmosView = {
        let starsCosmosView = CosmosView()
        starsCosmosView.isUserInteractionEnabled = false
        return starsCosmosView
    }()

    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = UIColor.clear
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 4
        return label
    }()

    let pictureView: UIImageView = {
        let pictureView = UIImageView()
        pictureView.contentMode = .scaleAspectFill
        pictureView.backgroundColor = UIColor.clear
        pictureView.contentMode = .scaleAspectFit
        pictureView.accessibilityLabel = ""
        return pictureView
    }()

    var comment: String = {
        var comment = ""
        return comment
    }()

    override func didSelect() {
        super.didSelect()

        if let data = cellModel.entryId {
            sendEvent(Self.touch, data: data)
        }
    }

    override func setupUI() {
        super.setupUI()

        contentView.addSubview(label)
        contentView.addSubview(pictureView)
        contentView.addSubview(starsCosmosView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = contentView.bounds
        let left: CGFloat = 15

        label.snp.makeConstraints { make in
            make.left.equalTo(pictureView.snp.right).offset(10)
            make.height.equalTo(25)
            make.top.equalToSuperview().inset(10)
        }

        pictureView.frame = CGRect(x: left, y: bounds.height - 95, width: 90 * 9 / 16, height: 90)
        starsCosmosView.frame = CGRect(x: left + 65, y: bounds.height - 30, width: bounds.width - 125, height: 25)
    }

    override func cellModelDidUpdate() {
        super.cellModelDidUpdate()

        label.text = cellModel.title
        print(cellModel.title)
        pictureView.image = cellModel.picture
        pictureView.accessibilityLabel = cellModel.title
        starsCosmosView.rating = cellModel.rating
        print("RATING \(cellModel.rating)")
        comment = cellModel.comment
    }
}
