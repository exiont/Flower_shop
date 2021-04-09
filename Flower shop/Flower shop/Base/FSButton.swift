//
//  FSButton.swift
//  Flower shop
//
//  Created by New on 9.04.21.
//

import UIKit

class FSButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton() {
        self.backgroundColor = FSColors.mainPink
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 5
        self.layer.borderColor = FSColors.brownRed.cgColor
        self.layer.borderWidth = 0.5
    }
}
