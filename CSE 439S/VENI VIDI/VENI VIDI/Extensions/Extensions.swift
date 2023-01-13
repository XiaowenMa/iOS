//
//  Extensions.swift
//  VENI VIDI
//
//  Created by MonAster on 2021/3/29.
//

import Foundation
import UIKit

extension UIImageView {
    func load(withURL urlString: String) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIViewController {

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc
    func dismissKeyboard(_: UITapGestureRecognizer) {
        view.endEditing(true)

        if let nav = navigationController {
            nav.view.endEditing(true)
        }
    }
}
