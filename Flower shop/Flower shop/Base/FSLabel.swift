//
//  FSLabel.swift
//  Flower shop
//
//  Created by New on 9.04.21.
//

import UIKit

class FSLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLabel() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = FSColors.brownRed
    }
}
