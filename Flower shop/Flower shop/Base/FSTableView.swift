//
//  FSTableView.swift
//  Flower shop
//
//  Created by New on 9.04.21.
//

import UIKit

class FSTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.setupTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = .white
        self.keyboardDismissMode = .onDrag
    }
}
