//
//  SearchCellModel.swift
//  VENI VIDI
//
//  Created by MonAster on 2021/3/9.
//
import DCFrame
import Foundation
import SnapKit
import UIKit

// MARK: - SearchCell

class SearchCell: DCBaseCell {
    static let searchChanged = DCEventID()
    static let searchText = DCSharedDataID()
    static let searchType = DCSharedDataID()
    static let cancelSearch = DCEventID()
    private var searchType = "book"
    private var searchText = ""

    private let segments: [(String, String)] = [("Books", "book"),
                                                ("Movies", "movie"),
                                                ("TV Shows", "show")]

    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        self.contentView.addSubview(view)
        view.delegate = self
        view.showsCancelButton = true
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes, for: .normal)
        return view
    }()

    private lazy var searchPicker: UISegmentedControl = {
        let searchPicker = UISegmentedControl(items: segments.map(\.0))
        searchPicker.selectedSegmentIndex = 0
        searchPicker.addTarget(self, action: #selector(SearchCell.changeSearchType(_:)), for: .valueChanged)
        contentView.addSubview(searchPicker)
        return searchPicker
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        searchPicker.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(30)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(searchPicker.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(56)
        }
    }

    @objc
    func changeSearchType(_ control: UISegmentedControl) {
        shareData(segments[control.selectedSegmentIndex].1, to: Self.searchType)
        textChanged(searchText)
    }

    private func textChanged(_ text: String) {
        setCellData(text)
        sendEvent(Self.searchChanged, data: text)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shareData(searchBar.text, to: Self.searchText)
        sendEvent(Self.cancelSearch, data: searchBar.text)
    }

    override func cellModelDidUpdate() {
        super.cellModelDidUpdate()
        searchBar.text = getCellData(default: "")
    }

    override func cellModelDidLoad() {
        super.cellModelDidLoad()

        subscribeData(UpdateEntryCell.titleText) { [weak self] (text: String) in
            self?.setCellData(text)
        }

        subscribeEvent(SearchResultCell.selectedVolume) { [weak self] (volume: EntryData) in
            self?.setCellData(volume.title)
            self?.searchBar.text = volume.title
            self?.sendEvent(Self.cancelSearch, data: volume.title)
        }
    }

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        searchBar.endEditing(true)
    }
}

// MARK: UISearchBarDelegate

extension SearchCell: UISearchBarDelegate {
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        textChanged(searchText)
    }

    func searchBarSearchButtonClicked(_: UISearchBar) {
        searchBar.endEditing(true)
        textChanged(searchText)
    }
}
