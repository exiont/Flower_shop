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
        self.tintColor = .white
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 5
        self.layer.borderColor = FSColors.brownRed.cgColor
        self.layer.borderWidth = 0.5
        self.semanticContentAttribute = .forceRightToLeft
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 0)

        self.snp.makeConstraints { (make) in
            make.height.equalTo(30)
        }
    }
}
