//
//  ViewController.swift
//  VENI VIDI
//
//  Created by 雲無心 on 2/12/21.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let vc = LaunchController()
        navigationController?.setViewControllers([vc], animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemYellow
    }
}
