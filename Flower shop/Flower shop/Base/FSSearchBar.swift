//
//  FSSearchBar.swift
//  Flower shop
//
//  Created by New on 9.04.21.
//

import UIKit

class FSSearchBar: UISearchBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSearchBar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSearchBar() {
        self.searchTextField.backgroundColor = FSColors.whitePink
        self.searchTextField.layer.cornerRadius = 5
        self.searchTextField.borderStyle = .none
        self.searchTextField.layer.borderWidth = 0.5
        self.searchTextField.layer.borderColor = FSColors.mainPink.cgColor
        self.searchTextField.textColor = FSColors.brownRed
        self.searchBarStyle = .minimal
        self.tintColor = FSColors.mainPink
    }
}
