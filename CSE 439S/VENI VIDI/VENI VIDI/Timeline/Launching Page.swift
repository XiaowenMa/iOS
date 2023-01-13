//
//  Launching Page.swift
//  VENI VIDI
//
//  Created by 马晓雯 on 4/9/21.
//

import DCFrame
import Foundation
import SnapKit
import UIKit

class LaunchController: UIViewController {
    var entries: [JournalEntry] = []
    var entryLabels: [FloatLabel] = []
    var clicked: Bool = false

    private let dataService = DataService(coreDataStack: CoreDataStack())

    func fetchEntries() {
        if let fetchResult = dataService.fetchAllJournalEntries() {
            entries = fetchResult
        }
    }

    func goToDetailedPage(id: UUID) {
        print(id)
        let detailedViewController = DetailedEntryViewController()
        detailedViewController.entryId = id

        navigationController?.pushViewController(detailedViewController, animated: true)
        navigationController?.viewControllers.removeAll(where: { vc -> Bool in
            if vc.isKind(of: LaunchController.self) || vc.isKind(of: LaunchController.self) {
                return true
            } else {
                return false
            }
        })
    }

    func gotoTimeline() {
        print("Timeline")
        let timelineVC = TimelineViewController()
        navigationController?.pushViewController(timelineVC, animated: true)
        navigationController?.viewControllers.removeAll(where: { vc -> Bool in
            if vc.isKind(of: LaunchController.self) || vc.isKind(of: LaunchController.self) {
                return true
            } else {
                return false
            }
        })
    }

    override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        clicked = true
        let touch = touches.first!
        let touchLocation = touch.location(in: view)

        for item in entryLabels {
            guard let labelFrame = item.layer.presentation()?.frame else { continue }
            if labelFrame.contains(touchLocation) {
                goToDetailedPage(id: item.id!)
                return
            }
        }
        gotoTimeline()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        entries = []
        entryLabels = []

        fetchEntries()
        print(entries.count)

        print("Launching Page")

        guard !entries.isEmpty else {
            let logoLabel: UILabel = {
                let logoLabel = UILabel()
                logoLabel.text = "VENI VIDI."
                logoLabel.font = UIFont.systemFont(ofSize: 15)
                return logoLabel
            }()
            view.addSubview(logoLabel)
            logoLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.height.equalTo(15)
            }
            UIView.animate(withDuration: 1.5,
                           animations: { logoLabel.transform = CGAffineTransform(scaleX: 3, y: 3) }) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.gotoTimeline()
                }
            }
            return
        }

        var index = 0
        var logoStarted = false
        view.backgroundColor = .black
        _ = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
            let label = FloatLabel()
            label.text = self.entries[index].entryTitle
            if let entryId = self.entries[index].id {
                label.id = entryId
            }
            self.entryLabels.append(label)

            self.view.addSubview(label)
            let yCoordinate = Int.random(in: 50 ..< Int(self.view.bounds.height - 100))
            let labelSize = Int.random(in: 15 ..< 50)
            let labelFrame = CGRect(x: Int(self.view.bounds.maxX), y: yCoordinate, width: 500, height: labelSize)
            label.frame = labelFrame
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: CGFloat(labelSize))

            UIView.animate(withDuration: 5,
                           delay: 0,
                           options: UIView.AnimationOptions.allowUserInteraction,
                           animations: { label.frame = CGRect(x: -600, y: yCoordinate, width: 600, height: labelSize) },
                           completion: { _ in label.removeFromSuperview()
                               print(self.view.subviews.count)
                               if self.view.subviews.count < 3, !logoStarted, !self.clicked {
                                   logoStarted = true
                                   let logoLabel: UILabel = {
                                       let logoLabel = UILabel()
                                       logoLabel.text = "VENI VIDI."
                                       logoLabel.font = UIFont.systemFont(ofSize: 15)
                                       return logoLabel
                                   }()
                                   self.view.addSubview(logoLabel)
                                   logoLabel.snp.makeConstraints { make in
                                       make.center.equalToSuperview()
                                       make.height.equalTo(15)
                                   }

                                   UIView.animate(withDuration: 1.5, animations: {
                                       self.view.backgroundColor = .clear
                                       logoLabel.transform = CGAffineTransform(scaleX: 3, y: 3)
                                   }) { _ in
                                       DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                           self.gotoTimeline()
                                       }
                                   }
                               }
                           })

            index += 1
            if index > self.entries.count - 1 {
                index = 0
                timer.invalidate()
            }
        }
    }
}
