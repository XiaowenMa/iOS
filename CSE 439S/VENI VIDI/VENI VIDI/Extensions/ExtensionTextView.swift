//
//  ExtensionTextView.swift
//  VENI VIDI
//
//  Created by 马晓雯 on 4/15/21.
//

import Foundation
import UIKit

class NewTextView: UITextView {
    override var contentSize: CGSize {
        didSet {
            var topCorrection = (bounds.size.height - contentSize.height * zoomScale) / 2.0
            topCorrection = max(0, topCorrection)
            contentInset = UIEdgeInsets(top: topCorrection, left: 0, bottom: 0, right: 0)
        }
    }
}
