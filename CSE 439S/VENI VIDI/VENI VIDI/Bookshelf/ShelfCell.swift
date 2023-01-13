//
//  ShelfCell.swift
//  VENI VIDI
//
//  Created by MonAster on 2021/4/26.
//

import DCFrame
import SnapKit
import UIKit

class ShelfCell: DCCell<ShelfCellModel>, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    static let entrySelected = DCEventID()
    var entries: [JournalEntry]?
    var sections = 0

    private let titleLabel = UILabel()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let separator = UIView()

    override func setupUI() {
        super.setupUI()
        configureViews()
        makeConstraints()
    }

    override func cellModelDidLoad() {
        super.cellModelDidLoad()

        if entries == [] {
            isHidden = true
        } else {
            isHidden = false
        }

        titleLabel.text = cellModel.title

        entries = cellModel.entries

        collectionView.reloadData()

        resize()
    }

    override func cellModelDidUpdate() {
        super.cellModelDidUpdate()

        if entries == [] {
            isHidden = true
        } else {
            isHidden = false
        }

        titleLabel.text = cellModel.title

        entries = cellModel.entries

        collectionView.reloadData()

        resize()
    }

    func resize() {
        guard var count = entries?.count else { return }
        let offset = count % 3 != 0 ? 1 : 0
        count /= 3
        count += offset
        sections = count
        cellModel.resize(height: CGFloat(50 + 250 * count))
        collectionView.snp.updateConstraints { make in
            make.height.equalTo((100 * 16 / 9 + 50) * count)
        }
    }

    func configureViews() {
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .systemYellow
        collectionView.register(ShelfCollectionCell.self, forCellWithReuseIdentifier: ShelfCollectionCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumInteritemSpacing = 15
            flowLayout.itemSize = CGSize(width: 100, height: 100 * 16 / 9 + 36)
        }
        separator.backgroundColor = .systemGray6
        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
        contentView.addSubview(separator)
    }

    func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(titleLabel.font.pointSize)
        }
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.height.equalTo(100 * 16 / 9 + 36)
        }
        separator.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(2)
        }
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        guard let count = entries?.count else { return 0 }
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShelfCollectionCell.identifier, for: indexPath)
        guard let shelfCell = cell as? ShelfCollectionCell else { return cell }

        if let entry = entries?[indexPath.item] {
            shelfCell.set(withEntry: entry)
        } else {
            shelfCell.setPlaceHolder()
        }
        return shelfCell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let entry = entries?[indexPath.item] else { return }
        sendEvent(Self.entrySelected, data: entry.id)
    }
}
