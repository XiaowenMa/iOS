//
//  ShelfContainerModel.swift
//  VENI VIDI
//
//  Created by MonAster on 2021/4/26.
//

import DCFrame
import SnapKit
import UIKit

class ShelfContainerModel: VVContainerModel {
    var entries: [JournalEntry]?
    var bookEntries: [JournalEntry] = []
    var movieEntries: [JournalEntry] = []
    var tvShowEntries: [JournalEntry] = []
    var currentTimeTag: TimeInterval = 0

    override func tableViewDataWillReload() {

        removeAllSubmodels()
        bookEntries = []
        movieEntries = []
        tvShowEntries = []

        getEntryData()

        if let entriesToDisplay = entries {
            for item in entriesToDisplay {
                switch item.journalType.rawValue {
                case "book":
                    bookEntries.append(item)
                case "movie":
                    movieEntries.append(item)
                case "tvShow":
                    tvShowEntries.append(item)
                default:
                    break
                }
            }
            let bookCollection = ShelfCellModel()
            bookCollection.set(withType: .book, withEntries: bookEntries)
            let movieCollection = ShelfCellModel()
            movieCollection.set(withType: .movie, withEntries: movieEntries)
            let tvShowCollection = ShelfCellModel()
            tvShowCollection.set(withType: .tvShow, withEntries: tvShowEntries)
            addSubmodels([bookCollection, movieCollection, tvShowCollection])
            if !movieEntries.isEmpty {
                let movieRecommendation = getRecommendations(withType: .movie)
                addSubmodel(movieRecommendation)
            }
            if !tvShowEntries.isEmpty {
                let tvShowRecommendation = getRecommendations(withType: .tvShow)
                addSubmodel(tvShowRecommendation)
            }
        }
    }

    override func cmDidLoad() {
        super.cmDidLoad()

        getEntryData()

        containerTableView?.contentInset = UIEdgeInsets(top: 150, left: 0, bottom: 100, right: 0)

        if let entriesToDisplay = entries {
            for item in entriesToDisplay {
                switch item.journalType.rawValue {
                case "book":
                    bookEntries.append(item)
                case "movie":
                    movieEntries.append(item)
                case "tvShow":
                    tvShowEntries.append(item)
                default:
                    break
                }
            }
            let bookCollection = ShelfCellModel()
            bookCollection.set(withType: .book, withEntries: bookEntries)
            let movieCollection = ShelfCellModel()
            movieCollection.set(withType: .movie, withEntries: movieEntries)
            let tvShowCollection = ShelfCellModel()
            tvShowCollection.set(withType: .tvShow, withEntries: tvShowEntries)
            addSubmodels([bookCollection, movieCollection, tvShowCollection])
            if !movieEntries.isEmpty {
                let movieRecommendation = getRecommendations(withType: .movie)
                addSubmodel(movieRecommendation)
            }
            if !tvShowEntries.isEmpty {
                let tvShowRecommendation = getRecommendations(withType: .tvShow)
                addSubmodel(tvShowRecommendation)
            }
        }
    }

    func getEntryData() {
        if let entries = dataService.fetchAllJournalEntries() {
            print(entries.count)
            self.entries = entries
        }
    }

    func getRecommendations(withType type: JournalEntryType) -> ShelfRecommendationCellModel {
        let recommendationCollection = ShelfRecommendationCellModel()
        let generalSearchAgent = GeneralSearchAgent()
        let timeStamp = NSDate().timeIntervalSince1970
        generalSearchAgent.getRecommendation(forContentType: type) { [weak self] result in
            guard let self = `self` else { return }
            switch result {
            case let .failure(error):
                print(error)
            case let .success(volumes):
                guard timeStamp >= self.currentTimeTag else {
                    return
                }
                self.currentTimeTag = timeStamp
                var recommendationEntries = volumes
                if volumes.count > 6 {
                    recommendationEntries = Array(volumes.prefix(6))
                }
                switch type {
                case .movie:
                    recommendationCollection.set(withType: .movie, withEntries: recommendationEntries)
                case .tvShow:
                    recommendationCollection.set(withType: .tvShow, withEntries: recommendationEntries)
                default:
                    break
                }
            }
        }
        return recommendationCollection
    }
}
