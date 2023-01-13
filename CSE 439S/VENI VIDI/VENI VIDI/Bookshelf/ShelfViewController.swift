//
//  ShelfViewController.swift
//  VENI VIDI
//
//  Created by MonAster on 2021/4/25.
//

import DCFrame
import SnapKit
import UIKit

class ShelfViewController: DCViewController {
    let shelfCM = ShelfContainerModel()

    override func viewWillAppear(_: Bool) {
        shelfCM.needReloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Shelf"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemYellow
        loadCM(shelfCM)

        EDC.subscribeEvent(ShelfCell.entrySelected, target: self) { [weak self] (id: UUID) in
            let detailedViewController = DetailedEntryViewController()
            detailedViewController.entryId = id
            self?.navigationController?.pushViewController(detailedViewController, animated: true)
        }
    }
}
