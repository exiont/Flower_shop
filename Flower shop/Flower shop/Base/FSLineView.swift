//
//  FSLineView.swift
//  Flower shop
//
//  Created by New on 9.04.21.
//

import UIKit

class FSLineView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLineView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLineView() {
        self.backgroundColor = FSColors.mainPink
        self.translatesAutoresizingMaskIntoConstraints = false

        self.snp.makeConstraints { (make) in
            make.height.equalTo(1)
        }
    }
}
