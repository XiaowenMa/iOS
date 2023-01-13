//
//  TimelineContainerModek.swift
//  VENI VIDI
//
//  Created by 马晓雯 on 2/26/21.
//

import DCFrame
import Foundation
import UIKit
import WidgetKit

// MARK: - SimpleListContainerModel

class SimpleListContainerModel: VVContainerModel {
    var entries: [JournalEntry]?
    var currentTimeLabel: DateComponents?
    var type: String = "all"

    func getEntryData() {
        if let entries = dataService.fetchAllJournalEntries() {
            print(entries.count)
            self.entries = entries
        }
    }

    override func tableViewDataWillReload() {
        print("CM Reloading")
        currentTimeLabel = Calendar.current.dateComponents([.day, .year, .month], from: Date())

        removeAllSubmodels()

        addSubCell(TimelinePickerCell.self) { model in
            model.cellHeight = 50
        }

        getEntryData()

        if let dateComponents = currentTimeLabel {
            createTimeLabel(date: dateComponents)
        }

        if let entriesToDisplay = entries {
            for item in entriesToDisplay {
                print(type)
                print(item.journalType)
                if type != "all" {
                    if item.journalType.rawValue != type {
                        continue
                    }
                }

                let calanderDate = Calendar.current.dateComponents([.day, .year, .month], from: item.finishDate!)
                guard let timeLabel = currentTimeLabel else { return }
                if calanderDate.year != timeLabel.year || calanderDate.month != timeLabel.month {
                    currentTimeLabel = calanderDate
                    print("Calendar Date is \(calanderDate)")
                    createTimeLabel(date: calanderDate)
                }

                let model = TimelineCellModel()

                if let id = item.id {
                    model.entryId = id
                }
                model.title = item.entryTitle ?? "No Title"
                if let imageData = item.image {
                    print(imageData)
                    model.picture = UIImage(data: imageData)
                } else {
                    model.picture = UIImage(systemName: "star.fill")
                }
                model.rating = Double(item.rating)
                addSubmodel(model, separator: .bottom, height: 2)
            }
        }
    }

    func createTimeLabel(date: DateComponents) {
        let timeModel = TimeLabelCellModel()
        switch date.month {
        case 1:
            timeModel.timeLabel = "\(date.year ?? 1970)  January"
        case 2:
            timeModel.timeLabel = "\(date.year ?? 1970)  February"
        case 3:
            timeModel.timeLabel = "\(date.year ?? 1970)  March"
        case 4:
            timeModel.timeLabel = "\(date.year ?? 1970)  April"
        case 5:
            timeModel.timeLabel = "\(date.year ?? 1970)  May"
        case 6:
            timeModel.timeLabel = "\(date.year ?? 1970)  June"
        case 7:
            timeModel.timeLabel = "\(date.year ?? 1970)  July"
        case 8:
            timeModel.timeLabel = "\(date.year ?? 1970)  August"
        case 9:
            timeModel.timeLabel = "\(date.year ?? 1970)  September"
        case 10:
            timeModel.timeLabel = "\(date.year ?? 1970)  Octuber"
        case 11:
            timeModel.timeLabel = "\(date.year ?? 1970)  November"
        case 12:
            timeModel.timeLabel = "\(date.year ?? 1970)  December"
        case .none:
            timeModel.timeLabel = ""
        case .some:
            timeModel.timeLabel = ""
        }
        addSubmodel(timeModel)
    }

    override func cmDidLoad() {
        super.cmDidLoad()

        containerTableView?.dc_delegate = self

        subscribeEvent(TimelinePickerCell.timelineTypeChanged) { [weak self] (type: String) in
            self?.type = type
            self?.needReloadData()
        }

        print("load Timeline")
        containerTableView?.contentInset = UIEdgeInsets(top: 150, left: 0, bottom: 150, right: 0)

        getEntryData()

        if let entriesToDisplay = entries, !entriesToDisplay.isEmpty {
            let widgetEntry = entriesToDisplay[0]
            let userDefault = UserDefaults(suiteName: "group.BEST-CSE439S-GROUP.VENI-VIDI.widget")
            if let widgetTitle = widgetEntry.entryTitle {
                userDefault?.setValue(widgetTitle, forKey: "title")
            }
            if let widgetCover = widgetEntry.image {
                userDefault?.setValue(widgetCover, forKey: "cover")
            }
            WidgetCenter.shared.reloadAllTimelines()
            for item in entriesToDisplay {
                if type != "all" {
                    if item.journalType.rawValue != type {
                        continue
                    }
                }

                let model = TimelineCellModel()

                if let id = item.id {
                    model.entryId = id
                }
                model.title = item.entryTitle ?? "No Title"
                if let imageData = item.image {
                    print(imageData)
                    model.picture = UIImage(data: imageData)
                } else {
                    model.picture = UIImage(systemName: "star.fill")
                }
                model.rating = Double(item.rating)

                addSubmodel(model)
            }
        }
    }
}

// MARK: DCTableViewDelegate, UITableViewDelegate

extension SimpleListContainerModel: DCTableViewDelegate, UITableViewDelegate {
    func dc_tableView(_: UITableView, editingStyleForRowAt _: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }

    func dc_tableView(_ tableView: UITableView, commit editStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editStyle == .delete {
            guard let table = tableView as? DCContainerTableView else { return }
            guard let cellModel = table.getCellModel(indexPath) as? TimelineCellModel else { return }
            guard let id = cellModel.entryId else { return }
            _ = dataService.deleteJournalEntry(withUUID: id)
            removeSubmodel(cellModel)

            needAnimateUpdate()
        }
    }

    public func tableView(_: UITableView, commit _: UITableViewCell.EditingStyle, forRowAt _: IndexPath) {}
}
