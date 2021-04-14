//
//  FSCounterButton.swift
//  Flower shop
//
//  Created by New on 9.04.21.
//

import UIKit

class FSCounterButton: UIButton {

    let boldCounterButtonTitleAttribute: [NSAttributedString.Key: Any] = [.foregroundColor: FSColors.mainPink,
                                                                          .font: UIFont.systemFont(ofSize: 17, weight: .bold)]
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupCounterButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCounterButton() {

    }
}
