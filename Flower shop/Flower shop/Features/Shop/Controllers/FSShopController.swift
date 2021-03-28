//
//  FSShopController.swift
//  Flower shop
//
//  Created by Eugene Hamitsevich on 3/21/21.
//

import UIKit
import SnapKit

class FSShopController: UIViewController {

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flower_logo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var appLabel: UILabel = {
        let label = UILabel()
        label.text = "Цветочный магазин"
        label.textColor = UIColor(named: "brown_red")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
    
        var customFont: UIFont
        if let caveat = UIFont(name: "Caveat-Regular", size: 30) {
            customFont = caveat
        } else {
            customFont = UIFont.systemFont(ofSize: 30)
        }
        label.font = customFont

        return label
    }()

    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Поиск"
        textField.borderStyle = .roundedRect

        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.addSubview(logoImageView)
        self.view.addSubview(appLabel)
        self.view.addSubview(searchTextField)
        self.setupConstraints()
    }

    func font() { // узнать имя семейства шрифта
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }

    private func setupConstraints() {
        self.logoImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(50)
            make.left.right.equalToSuperview()
        }

        self.appLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.logoImageView.snp.bottom)
            make.left.right.equalToSuperview()
        }

        self.searchTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.appLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(15)
        }
    }
}
