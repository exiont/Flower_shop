//
//  FSAuthorizationController.swift
//  Flower shop
//
//  Created by Eugene Hamitsevich on 3/28/21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class FSAuthorizationController: FSViewController {

    let underlineTitleAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: FSColors.mainPink,
                                                                  .underlineStyle: NSUnderlineStyle.single.rawValue]

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
        label.textColor = FSColors.brownRed
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.applyCustomFont(name: "Caveat-Regular", size: 30)

        return label
    }()

    private lazy var authorizationSegmentedControlView: FSSegmentedControlView = {
        let view = FSSegmentedControlView()
        view.segmentedControl.insertSegment(withTitle: "Вход", at: 0, animated: false)
        view.segmentedControl.insertSegment(withTitle: "Регистрация", at: 1, animated: false)
        view.segmentedControl.selectedSegmentIndex = 0
        view.segmentedControl.addTarget(self, action: #selector(self.changeLoginOrRegiser(sender:)), for: .valueChanged)
        return view
    }()

    private lazy var nameTextField: FSTextField = {
        let textField = FSTextField()
        textField.placeholder = "Имя"
        textField.isHidden = true
        textField.delegate = self
        return textField
    }()

    private lazy var surnameTextField: FSTextField = {
        let textField = FSTextField()
        textField.placeholder = "Фамилия"
        textField.isHidden = true
        textField.delegate = self
        return textField
    }()

    private lazy var emailTextField: FSTextField = {
        let textField = FSTextField()
        textField.placeholder = "E-mail"
        textField.keyboardType = .emailAddress
        textField.textContentType = .emailAddress
        textField.delegate = self
        return textField
    }()

    private lazy var passwordTextField: FSTextField = {
        let textField = FSTextField()
        textField.placeholder = "Пароль"
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        textField.delegate = self
        return textField
    }()

    private lazy var confirmPasswordTextField: FSTextField = {
        let textField = FSTextField()
        textField.placeholder = "Подтвердите пароль"
        textField.isSecureTextEntry = true
        textField.isHidden = true
        textField.delegate = self
        return textField
    }()

    private lazy var authorizationButton: FSButton = {
        let button = FSButton()
        button.setTitle("ВХОД", for: .normal)
        button.addTarget(self, action: #selector(logInButtonDidTap), for: .touchUpInside)

        return button
    }()

    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        let attributedTitle = NSAttributedString(string: "Забыли пароль?", attributes: self.underlineTitleAttributes)
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(forgotPasswordButtonDidTap), for: .touchUpInside)

        return button
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewDidTapped)))
        self.view.addSubview(logoImageView)
        self.view.addSubview(appLabel)
        self.view.addSubview(authorizationSegmentedControlView)
        self.view.addSubview(nameTextField)
        self.view.addSubview(surnameTextField)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(confirmPasswordTextField)
        self.view.addSubview(authorizationButton)
        self.view.addSubview(forgotPasswordButton)
        self.updateViewConstraints()
    }

    override func updateViewConstraints() {
        self.logoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }

        self.appLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.logoImageView.snp.bottom)
            make.left.right.equalToSuperview()
        }

        self.authorizationSegmentedControlView.snp.makeConstraints { (make) in
            make.top.equalTo(self.appLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }

        self.nameTextField.snp.remakeConstraints { (make) in
            make.top.equalTo(self.authorizationSegmentedControlView.snp.bottom).offset(0)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(0)
        }

        self.surnameTextField.snp.remakeConstraints { (make) in
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

        self.confirmPasswordTextField.snp.remakeConstraints { (make) in
            make.top.equalTo(self.passwordTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(0)
        }
        self.authorizationButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.confirmPasswordTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(45)
        }

        self.forgotPasswordButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.authorizationButton.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(45)
        }

        super.updateViewConstraints()

    }

    @objc func logInButtonDidTap() {
        let hasErrors = self.checkForLoginErrors()
        if !hasErrors,
           let email = emailTextField.text,
           let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
                guard let self = self else { return }
                if let error = error as NSError? {
                    self.showAlert(message: error.localizedDescription, title: "Авторизация")
                } else {
                    guard let scene = UIApplication.shared.connectedScenes.first,
                          let sceneDelegate = scene.delegate as? SceneDelegate else { return }
                    let tabBarVC = FSTabBarController()
                    sceneDelegate.changeRootViewConroller(tabBarVC)
                }
            }
        }
    }

    @objc func registerButtonDidTap() {
        let hasErrors = self.checkForRegistrationErrors()
        if !hasErrors,
           let email = emailTextField.text,
           let password = passwordTextField.text,
           let name = nameTextField.text,
           let surname = surnameTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
                guard let self = self else { return }
                if let error = error as NSError? {
                    self.showAlert(message: error.localizedDescription, title: "Авторизация")
                } else {
                    let name = "\(name) \(surname)"
                    guard let user = Auth.auth().currentUser else { return }
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = name
                    changeRequest.commitChanges { (error) in
                        if let error = error {
                            self.showAlert(message: error.localizedDescription, title: "Авторизация")
                        }
                    }
                }
            }
            guard let scene = UIApplication.shared.connectedScenes.first,
                  let sceneDelegate = scene.delegate as? SceneDelegate else { return }
            let tabBarVC = FSTabBarController()
            sceneDelegate.changeRootViewConroller(tabBarVC)
        }
    }

    @objc func forgotPasswordButtonDidTap() {
        guard let email = emailTextField.text, !email.isEmpty else {
            self.alertWithTitle(title: "Восстановление пароля", message: "Пожалуйста, введите ваш e-mail, указанный при регистрации.", toFocus: self.emailTextField)
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self = self else { return }
            if let error = error as NSError? {
                self.showAlert(message: error.localizedDescription, title: "Восстановление пароля")
            } else {
                self.showAlert(message: "Письмо с инструкцией по сбросу пароля отправлено на ваш e-mail.", title: "Восстановление пароля")
            }
        }

    }

    @objc private func viewDidTapped() {
        self.view.endEditing(true)
    }

    @objc func changeLoginOrRegiser(sender: UISegmentedControl) {
        self.authorizationButton.removeTarget(nil, action: nil, for: .allEvents)

        switch sender.selectedSegmentIndex {
        case 0:
            self.nameTextField.isHidden = true
            self.nameTextField.snp.remakeConstraints { (make) in
                make.top.equalTo(self.authorizationSegmentedControlView.snp.bottom).offset(0)
                make.height.equalTo(0)
            }

            self.surnameTextField.isHidden = true
            self.surnameTextField.snp.remakeConstraints { (make) in
                make.top.equalTo(self.nameTextField.snp.bottom).offset(0)
                make.height.equalTo(0)
            }

            self.confirmPasswordTextField.isHidden = true
            self.confirmPasswordTextField.snp.remakeConstraints { (make) in
                make.top.equalTo(self.passwordTextField.snp.bottom).offset(0)
                make.height.equalTo(0)
            }

            self.authorizationSegmentedControlView.leftBottomUnderlineView.isHidden.toggle()
            self.authorizationSegmentedControlView.rightBottomUnderlineView.isHidden.toggle()
            self.forgotPasswordButton.isHidden = false

            self.authorizationButton.setTitle("Вход", for: UIControl.State())
            self.authorizationButton.addTarget(self, action: #selector(logInButtonDidTap), for: .touchUpInside)
        case 1:
            self.nameTextField.isHidden = false
            self.nameTextField.snp.remakeConstraints { (make) in
                make.top.equalTo(self.authorizationSegmentedControlView.snp.bottom).offset(10)
                make.left.right.equalToSuperview().inset(15)
                make.height.equalTo(self.passwordTextField.snp.height)
            }

            self.surnameTextField.isHidden = false
            self.surnameTextField.snp.remakeConstraints { (make) in
                make.top.equalTo(self.nameTextField.snp.bottom).offset(10)
                make.left.right.equalToSuperview().inset(15)
                make.height.equalTo(self.passwordTextField.snp.height)
            }

            self.confirmPasswordTextField.isHidden = false
            self.confirmPasswordTextField.snp.remakeConstraints { (make) in
                make.top.equalTo(self.passwordTextField.snp.bottom).offset(10)
                make.left.right.equalToSuperview().inset(15)
                make.height.equalTo(self.passwordTextField.snp.height)
            }

            self.authorizationSegmentedControlView.leftBottomUnderlineView.isHidden.toggle()
            self.authorizationSegmentedControlView.rightBottomUnderlineView.isHidden.toggle()
            self.forgotPasswordButton.isHidden = true

            self.authorizationButton.setTitle("Регистрация", for: UIControl.State())
            self.authorizationButton.addTarget(self, action: #selector(registerButtonDidTap), for: .touchUpInside)
        default:
            break
        }
    }

    @discardableResult
    func checkForRegistrationErrors() -> Bool {

        let title = "Ошибка"
        var message = ""
        var errors = false

        if let name = self.nameTextField.text,
           let surname = self.surnameTextField.text,
           let email = self.emailTextField.text,
           let password = self.passwordTextField.text,
           let confirmedPassword = self.confirmPasswordTextField.text {
            if name.isEmpty {
                errors = true
                message += "Введите имя"
                alertWithTitle(title: title, message: message, toFocus: self.nameTextField)
            } else if surname.isEmpty {
                errors = true
                message += "Введите фамилию"
                alertWithTitle(title: title, message: message, toFocus: self.nameTextField)
            } else if email.isEmpty {
                errors = true
                message += "Введите e-mail"
                alertWithTitle(title: title, message: message, toFocus: self.emailTextField)
            } else if !email.contains("@") && !email.contains(".") {
                errors = true
                message += "Неверный e-mail адрес"
                alertWithTitle(title: title, message: message, toFocus: self.emailTextField)
            } else if password.isEmpty {
                errors = true
                message += "Введите пароль"
                alertWithTitle(title: title, message: message, toFocus: self.passwordTextField)
            } else if password.count < 8 {
                errors = true
                message += "Пароль не может содержать менее 8 знаков"
                alertWithTitle(title: title, message: message, toFocus: self.passwordTextField)
            } else if password != confirmedPassword {
                errors = true
                message += "Пароли не совпадают"
                alertWithTitle(title: title, message: message, toFocus: self.confirmPasswordTextField)
            }
        }

        return errors
    }

    @discardableResult
    func checkForLoginErrors() -> Bool {

        let title = "Ошибка"
        var message = ""
        var errors = false

        if let email = self.emailTextField.text,
           let password = self.passwordTextField.text {
            if email.isEmpty {
                errors = true
                message += "Введите e-mail"
                alertWithTitle(title: title, message: message, toFocus: self.emailTextField)
            } else if !email.contains("@") && !email.contains(".") {
                errors = true
                message += "Неверный e-mail адрес"
                alertWithTitle(title: title, message: message, toFocus: self.emailTextField)
            } else if password.isEmpty {
                errors = true
                message += "Введите пароль"
                alertWithTitle(title: title, message: message, toFocus: self.passwordTextField)
            } else if password.count < 8 {
                errors = true
                message += "Пароль не может содержать менее 8 знаков"
                alertWithTitle(title: title, message: message, toFocus: self.passwordTextField)
            }
        }

        return errors
    }
}

extension FSAuthorizationController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if authorizationSegmentedControlView.segmentedControl.selectedSegmentIndex == 1 {
            switch textField {
            case self.nameTextField:
                self.surnameTextField.becomeFirstResponder()
            case self.surnameTextField:
                self.emailTextField.becomeFirstResponder()
            case self.emailTextField:
                self.passwordTextField.becomeFirstResponder()
            case self.passwordTextField:
                self.confirmPasswordTextField.becomeFirstResponder()
            default:
                self.checkForRegistrationErrors()
            }
        } else {
            switch textField {
            case self.emailTextField:
                self.passwordTextField.becomeFirstResponder()
            default:
                self.checkForLoginErrors()
            }

        }

        return true
    }
}
