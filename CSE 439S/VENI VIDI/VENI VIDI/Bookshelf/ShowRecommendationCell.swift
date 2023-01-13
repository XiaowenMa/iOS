//
//  ShowRecommendationCell.swift
//  VENI VIDI
//
//  Created by MonAster on 2021/5/3.
//

import DCFrame
import Foundation
import SnapKit
import UIKit

// MARK: - ShowRecommendationCell

class ShowRecommendationCell: DCCell<ShowRecommendationCellModel> {
    static let showRecommendations = DCEventID()

    var title = ""

    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Show Recommendations", for: .normal)
        button.setTitleColor(.systemYellow, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()

    override func setupUI() {
        super.setupUI()

        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
    }

    override func layoutSubviews() {
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(16)
            make.width.equalToSuperview()
        }
    }

    override func cellModelDidLoad() {
        super.cellModelDidLoad()

        title = cellModel.showing ? "Hide Recommendations" : "Show Recommendations"
        button.setTitle(title, for: .normal)
    }

    override func cellModelDidUpdate() {
        super.cellModelDidUpdate()

        title = cellModel.showing ? "Hide Recommendations" : "Show Recommendations"
        button.setTitle(title, for: .normal)
    }

    @objc
    func tap() {
        cellModel.showing = !cellModel.showing
        title = cellModel.showing ? "Hide Recommendations" : "Show Recommendations"
        button.setTitle(title, for: .normal)
        sendEvent(Self.showRecommendations, data: cellModel.showing)
    }
}

// MARK: - ShowRecommendationCellModel

class ShowRecommendationCellModel: DCCellModel {
    var showing = false

    required init() {
        super.init()
        cellClass = ShowRecommendationCell.self
        cellHeight = 30
    }
}
