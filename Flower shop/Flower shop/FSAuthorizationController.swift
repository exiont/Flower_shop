//
//  FSAuthorizationController.swift
//  Flower shop
//
//  Created by Eugene Hamitsevich on 3/28/21.
//

import UIKit

class FSAuthorizationController: UIViewController {

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

    private lazy var authorizationSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Вход","Регистрация"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.cornerRadius = 5
        segmentedControl.tintColor = .black
        segmentedControl.backgroundColor = .white
        segmentedControl.addTarget(self, action: #selector(self.changeLoginOrRegiser(sender:)), for: .valueChanged)

        return segmentedControl
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Имя"
        textField.borderStyle = .roundedRect
        textField.isHidden = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var surnameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Фамилия"
        textField.borderStyle = .roundedRect
        textField.isHidden = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "E-mail"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Пароль"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var authorizationButton: UIButton = {
        let button = UIButton()
        button.setTitle("ВХОД", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(UIColor(named: "main_pink"), for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderColor = CGColor(srgbRed: 0.941, green: 0.408, blue: 0.561, alpha: 1)
        button.layer.borderWidth = 1

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.addSubview(logoImageView)
        self.view.addSubview(appLabel)
        self.view.addSubview(authorizationSegmentedControl)
        self.view.addSubview(nameTextField)
        self.view.addSubview(surnameTextField)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(authorizationButton)
        self.setupConstraints()
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

        self.authorizationSegmentedControl.snp.makeConstraints { (make) in
            make.top.equalTo(self.appLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(15)
        }

        self.nameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.authorizationSegmentedControl.snp.bottom).offset(0)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(0)
        }

        self.surnameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameTextField.snp.bottom).offset(0)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(0)
        }

        self.emailTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.surnameTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(15)
        }

        self.passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.emailTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(15)
        }

        self.authorizationButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.passwordTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(45)
        }

    }

    @objc func changeLoginOrRegiser(sender: UISegmentedControl) {
        self.authorizationButton.removeTarget(nil, action: nil, for: .allEvents)

        switch sender.selectedSegmentIndex {
        case 0:
            self.nameTextField.isHidden = true
            self.nameTextField.snp.remakeConstraints { (make) in
                make.top.equalTo(self.authorizationSegmentedControl.snp.bottom).offset(0)
                make.height.equalTo(0)
            }

            self.surnameTextField.isHidden = true
            self.surnameTextField.snp.remakeConstraints { (make) in
                make.top.equalTo(self.nameTextField.snp.bottom).offset(0)
                make.height.equalTo(0)
            }
            self.authorizationButton.setTitle("Вход", for: UIControl.State())
        case 1:
            self.nameTextField.isHidden = false
            self.nameTextField.snp.remakeConstraints { (make) in
                make.top.equalTo(self.authorizationSegmentedControl.snp.bottom).offset(10)
                make.left.right.equalToSuperview().inset(15)
                make.height.equalTo(self.passwordTextField.snp.height)
            }

            self.surnameTextField.isHidden = false
            self.surnameTextField.snp.remakeConstraints { (make) in
                make.top.equalTo(self.nameTextField.snp.bottom).offset(10)
                make.left.right.equalToSuperview().inset(15)
                make.height.equalTo(self.passwordTextField.snp.height)
            }
            self.authorizationButton.setTitle("Регистрация", for: UIControl.State())
        default:
            break
        }
    }
}
