//
//  TimelineViewController.swift
//  VENI VIDI
//
//  Created by 马晓雯 on 2/26/21.
//

import DCFrame
import Foundation
import SnapKit
import UIKit

class TimelineViewController: DCViewController {
    let simpleListCM = SimpleListContainerModel()

    override func viewWillAppear(_: Bool) {
        print("Reloading")
        navigationItem.backBarButtonItem = nil

        simpleListCM.needReloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(onAdd))
        navigationController?.navigationBar.barTintColor = UIColor.systemBackground

        title = "Timeline"

        EDC.subscribeEvent(TimelineCell.touch, target: self) { [weak self] (data: UUID) in
            print("pushing View Controller")
            guard let self = self else {
                return
            }
            let detailedVC = DetailedEntryViewController()
            detailedVC.entryId = data

            self.navigationController?.pushViewController(detailedVC, animated: true)
        }
        loadCM(simpleListCM)
    }

    @objc
    func onAdd() {
        let updateEntryVC = UpdateEnrtyViewController()
        navigationController?.pushViewController(updateEntryVC, animated: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
