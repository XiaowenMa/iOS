//
//  ExtensionNav.swift
//  VENI VIDI
//
//  Created by 马晓雯 on 4/10/21.
//

import Foundation
import UIKit
extension UINavigationController {
    var previousViewController: UIViewController? {
        guard let nav = navigationController else { return nil }
        let count = nav.viewControllers.count
        return count < 2 ? nil : nav.viewControllers[count - 2]
    }
}
