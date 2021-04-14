//
//  FSSegmentedControl.swift
//  Flower shop
//
//  Created by New on 9.04.21.
//

import UIKit

class FSSegmentedControl: UISegmentedControl {
    let regularSegmentedControlTitleAttribute: [NSAttributedString.Key: Any] = [.foregroundColor: FSColors.brownRed,
                                                                                .font: UIFont.systemFont(ofSize: 16, weight: .regular)]
    let boldSegmentedControlTitleAttribute: [NSAttributedString.Key: Any] = [.foregroundColor: FSColors.brownRed,
                                                                             .font: UIFont.systemFont(ofSize: 16, weight: .bold)]
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSegmentedControl()
    }

    override init(items: [Any]?) {
        super.init(items: items)
        self.setupSegmentedControl()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSegmentedControl() {
        self.selectedSegmentIndex = 0
        self.tintColor = .clear
        self.backgroundColor = .clear
        self.setTitleTextAttributes(regularSegmentedControlTitleAttribute, for: .normal)
        self.setTitleTextAttributes(boldSegmentedControlTitleAttribute, for: .selected)
        self.removeStyle()
    }
}
