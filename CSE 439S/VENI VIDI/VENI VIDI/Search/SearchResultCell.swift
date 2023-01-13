//
//  SearchResultCell.swift
//  VENI VIDI
//
//  Created by MonAster on 2021/3/22.
//
import DCFrame
import Foundation
import SnapKit

// MARK: - SearchResultCellModel

class SearchResultCellModel: DCCellModel {
    var cover: UIImage?
    var title: String = ""
    var coverURL: String = ""
    var volume: EntryData?

    required init() {
        super.init()
        cellHeight = 120
        cellClass = SearchResultCell.self
    }
}

// MARK: - SearchResultCell

class SearchResultCell: DCCell<SearchResultCellModel> {
    static let selectedVolume = DCEventID()

    var coverView = UIImageView()
    var titleView = UILabel()

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.addSubview(coverView)
        contentView.addSubview(titleView)

        coverView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.bottom.equalTo(10)
            make.width.equalTo(120 * 9 / 16)
        }

        titleView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(coverView.snp.right).offset(50)
            make.width.equalTo(300)
        }
    }

    override func cellModelDidLoad() {
        super.cellModelDidLoad()
        titleView.text = cellModel.title
        titleView.font = UIFont.systemFont(ofSize: 20)
        let str = cellModel.coverURL.replacingOccurrences(of: "http:", with: "https:")
        guard let url = URL(string: str) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else { return }
                self.coverView.image = image
            }
        }

        task.resume()
    }

    override func didSelect() {
        super.didSelect()
        sendEvent(Self.selectedVolume, data: cellModel.volume)
    }
}
