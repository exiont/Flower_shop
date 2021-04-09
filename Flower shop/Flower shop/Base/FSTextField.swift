//
//  FSUITextField.swift
//  Flower shop
//
//  Created by New on 8.04.21.
//

import UIKit

class FSTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupTextField()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTextField() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.borderStyle = .none
        self.layer.borderWidth = 0.5
        self.layer.borderColor = FSColors.mainPink.cgColor
        self.layer.cornerRadius = 5
        self.tintColor = FSColors.mainPink
        self.backgroundColor = FSColors.whitePink
        self.textColor = FSColors.brownRed
        self.clearButtonMode = .whileEditing
        self.translatesAutoresizingMaskIntoConstraints = false
        self.attributedPlaceholder = NSAttributedString(string: " ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])

        self.snp.makeConstraints { (make) in
            make.height.equalTo(30)
        }
    }

}
