//
//  FSSeparatorView.swift
//  Flower shop
//
//  Created by New on 14.04.21.
//

import UIKit

class FSSeparatorView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        self.backgroundColor = FSColors.mainPink
        self.translatesAutoresizingMaskIntoConstraints = false
    }

}
