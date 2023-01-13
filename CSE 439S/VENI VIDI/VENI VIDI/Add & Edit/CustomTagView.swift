//
//  CustomTagView.swift
//  VENI VIDI
//
//  Created by 马晓雯 on 4/27/21.
//

import Foundation
import UIKit

class CustomTagView: UIView {

    var tagLabel = UITextView()
    var cancel = UIButton()

    // initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    // initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .systemPink
        addSubview(tagLabel)
        addSubview(cancel)
    }

    @objc
    func removeTag() {
//        removeFromSuperview()
    }
}
