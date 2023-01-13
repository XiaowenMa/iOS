//
//  SearchCM.swift
//  VENI VIDI
//
//  Created by MonAster on 2021/3/22.
//
import DCFrame
import Foundation
import SnapKit

class SearchCM: DCContainerModel {
    private let searchResultCM = DCContainerModel()
    var currentTimeTag: TimeInterval = 0
    static let searchNotEmpty = DCEventID()
    static let searchEmpty = DCEventID()
    private var searchType = "book"
    private let segments: [(String, String)] = [("Books", "book"),
                                                ("Movies", "movie"),
                                                ("TV Shows", "show")]

    override func cmDidLoad() {
        super.cmDidLoad()
        addSubCell(SearchCell.self) { model in
            model.cellHeight = 101
        }
        addSubmodel(searchResultCM)
        handleEvents()
    }

    @objc
    func changeSearchType(_ control: UISegmentedControl) {
        searchType = segments[control.selectedSegmentIndex].1
    }

    private func handleEvents() {
        subscribeEvent(SearchCell.searchChanged) { [weak self] (text: String) in
            guard let self = self else {
                return
            }
            if text != "" {
                switch self.searchType {
                case "book":
                    self.getBooks(with: text)
                case "movie":
                    self.getMovies(with: text, type: .movie)
                case "show":
                    self.getMovies(with: text, type: .tvShow)
                case "game":
                    self.getGames(with: text)
                default:
                    self.getBooks(with: text)
                }

                self.sendEvent(Self.searchNotEmpty)
            } else {
                self.searchResultCM.removeAllSubmodels()
                self.needAnimateUpdate()
                self.sendEvent(Self.searchEmpty)
            }
        }.and(SearchCell.cancelSearch) { [weak self] in
            self?.searchResultCM.removeAllSubmodels()
            self?.needAnimateUpdate()
        }
        subscribeData(SearchCell.searchType) { [weak self] (type: String) in
            self?.searchType = type
        }
    }

    private func getBooks(with text: String) {
        let request = BookRequest(with: text)
        let timeStamp = NSDate().timeIntervalSince1970
        request.getBooks { [weak self] result in
            switch result {
            case let .failure(error):
                print(error)
                self?.searchResultCM.removeAllSubmodels()
            case let .success(volumes):
                var i = 0
                guard let tag = self?.currentTimeTag, timeStamp >= tag else {
                    return
                }
                self?.currentTimeTag = timeStamp
                self?.searchResultCM.removeAllSubmodels()
                for volume in volumes {
                    if i == 5 {
                        break
                    }
                    let info = volume.volumeInfo
                    let resultModel = SearchResultCellModel()
                    resultModel.title = info.title
                    i += 1
                    guard let image = info.imageLinks.thumbnail else {
                        continue
                    }
                    resultModel.coverURL = image
                    resultModel.volume = EntryData(withTitle: info.title, image: image, asType: .book)
                    self?.searchResultCM.addSubmodel(resultModel)
                }
            }
            self?.needAnimateUpdate()
        }
    }

    private func getMovies(with text: String, type: QueryContentType) {
        let generalSearchAgent = GeneralSearchAgent()
        let timeStamp = NSDate().timeIntervalSince1970
        generalSearchAgent.query(withKeyword: text, forContentType: type) { [weak self] result in
            switch result {
            case let .failure(error):
                print(error)
                self?.searchResultCM.removeAllSubmodels()
            case let .success(volumes):
                var i = 0
                guard let tag = self?.currentTimeTag, timeStamp >= tag else {
                    return
                }
                self?.currentTimeTag = timeStamp
                self?.searchResultCM.removeAllSubmodels()
                for volume in volumes {
                    if i == 5 {
                        break
                    }
                    let resultModel = SearchResultCellModel()
                    resultModel.title = volume.title
                    i += 1
                    guard let image = volume.coverUrl else {
                        continue
                    }
                    resultModel.coverURL = image

                    switch type {
                    case .movie:
                        resultModel.volume = EntryData(withTitle: volume.title, image: image, asType: .movie)
                    case .tvShow:
                        resultModel.volume = EntryData(withTitle: volume.title, image: image, asType: .tvShow)
                    default:
                        resultModel.volume = EntryData(withTitle: volume.title, image: image, asType: .movie)
                    }
                    self?.searchResultCM.addSubmodel(resultModel)
                }
            }
            self?.needAnimateUpdate()
        }
    }

    func getGames(with text: String) {
        let generalSearchAgent = GeneralSearchAgent()
        let timeStamp = NSDate().timeIntervalSince1970
        generalSearchAgent.query(withKeyword: text, forContentType: .game) { [weak self] result in
            switch result {
            case let .failure(error):
                print(error)
                self?.searchResultCM.removeAllSubmodels()
            case let .success(volumes):
                var i = 0
                guard let tag = self?.currentTimeTag, timeStamp >= tag else {
                    return
                }
                self?.currentTimeTag = timeStamp
                self?.searchResultCM.removeAllSubmodels()
                for volume in volumes {
                    if i == 5 {
                        break
                    }
                    let resultModel = SearchResultCellModel()
                    resultModel.title = volume.title
                    i += 1
                    guard let image = volume.coverUrl else {
                        continue
                    }
                    resultModel.coverURL = image
                    resultModel.volume = EntryData(withTitle: volume.title, image: image, asType: .game)
                    self?.searchResultCM.addSubmodel(resultModel)
                }
            }
            self?.needAnimateUpdate()
        }
    }

    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    func downloadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else { return }
                completion(.success(image))
            }
        }
    }
}
