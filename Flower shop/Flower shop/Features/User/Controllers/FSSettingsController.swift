//
//  FSSettingsController.swift
//  Flower shop
//
//  Created by New on 14.04.21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol FSSettingsControllerDelegate: class {
    func updateUserAddress(with address: String)
    func updateUserEmail(with email: String)
    func updateUserName(with name: String)
}

class FSSettingsController: FSViewController {
    weak var delegate: FSSettingsControllerDelegate?

    private lazy var menuTableView: FSTableView = {
        let tableView = FSTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FSProfileMenuCell.self, forCellReuseIdentifier: FSProfileMenuCell.reuseIdentifier)
        tableView.isScrollEnabled = false

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Настройки"
        self.view.addSubview(self.menuTableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func updateViewConstraints() {

        self.menuTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(5)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.greaterThanOrEqualToSuperview()
        }

        super.updateViewConstraints()
    }
}

extension FSSettingsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FSProfileMenuCell.reuseIdentifier, for: indexPath) as? FSProfileMenuCell else { return UITableViewCell() }

        switch indexPath.row {
        case 0:
            if let image = UIImage(systemName: "house") {
                cell.setCell(image: image, title: "Изменить адрес")
            }
        case 1:
            if let image = UIImage(systemName: "mail") {
                cell.setCell(image: image, title: "Изменить имя")
            }
        case 2:
            if let image = UIImage(systemName: "envelope.badge") {
                cell.setCell(image: image, title: "Изменить почту")
            }
        case 3:
            if let image = UIImage(systemName: "key") {
                cell.setCell(image: image, title: "Изменить пароль")
            }
        default:
            break
        }
        cell.selectionStyle = .none

        return cell
    }
}

extension FSSettingsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let alert = UIAlertController(title: "", message: "Изменить адрес", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Новый адрес"
                textField.autocorrectionType = .no
            }
            alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { [weak alert] _ in
                guard let textfield = alert?.textFields?[0], let newAddress = textfield.text else { return }
                if newAddress.isEmpty {
                    self.showAlert(message: "Введите адрес", title: "Ошибка")
                } else {
                    guard let user = Auth.auth().currentUser else { return }
                    let addresses = Firestore.firestore().collection("addresses")
                    let userAddress = addresses.document(user.uid)
                    userAddress.setData(["address": newAddress]) { [weak self] error in
                        guard let self = self else { return }
                        if let error = error {
                            self.showAlert(message: error.localizedDescription, title: "Ошибка")
                        } else {
                            self.delegate?.updateUserAddress(with: newAddress)
                            self.showAlert(message: "Адрес успешно изменён.", title: "")
                        }
                    }
                }
            }))
            self.present(alert, animated: true, completion: nil)
        case 1:
            let alert = UIAlertController(title: "", message: "Изменить имя пользователя", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Новое имя"
            }
            alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { [weak alert] (_) in
                guard let textfield = alert?.textFields?[0], let newUsername = textfield.text else { return }
                if newUsername.isEmpty {
                    self.showAlert(message: "Поле имени не может быть пустым", title: "Ошибка")
                } else {
                    guard let user = Auth.auth().currentUser else { return }
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = newUsername
                    changeRequest.commitChanges { [weak self] error in
                        guard let self = self else { return }
                        if let error = error {
                            self.showAlert(message: error.localizedDescription, title: "Ошибка")
                        } else {
                            self.delegate?.updateUserName(with: newUsername)
                            self.showAlert(message: "Имя успешно изменёно.", title: "")
                        }
                    }
                }
            }))
            self.present(alert, animated: true, completion: nil)
        case 2:
            let alert = UIAlertController(title: "", message: "Изменить e-mail", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Новый e-mail"
                textField.keyboardType = .emailAddress
                textField.autocorrectionType = .no
            }
            alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { [weak alert] _ in
                guard let textfield = alert?.textFields?[0], let newEmail = textfield.text else { return }
                if newEmail.isEmpty || !newEmail.contains("@") || !newEmail.contains(".") {
                    self.showAlert(message: "Введен неправильный e-mail", title: "Ошибка")
                } else {
                    guard let user = Auth.auth().currentUser else { return }
                    user.updateEmail(to: newEmail, completion: { [weak self] error in
                        guard let self = self else { return }
                        if let error = error {
                            self.showAlert(message: error.localizedDescription, title: "Ошибка")
                        } else {
                            self.delegate?.updateUserEmail(with: newEmail)
                            self.showAlert(message: "Ваш email успешно изменён.", title: "")
                        }
                    })
                }
            }))
            self.present(alert, animated: true, completion: nil)
        case 3:
            let alert = UIAlertController(title: "", message: "Введите новый пароль", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Новый пароль"
                textField.isSecureTextEntry = true
            }
            alert.addTextField { (textFieldPass) in
                textFieldPass.placeholder = "Повторите пароль"
                textFieldPass.isSecureTextEntry = true
            }
            alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { [weak alert] _ in
                guard let newPassword = alert?.textFields?[0].text, let repeatPassword = alert?.textFields?[1].text else { return }
                if newPassword.isEmpty || repeatPassword.isEmpty {
                    self.showAlert(message: "Введите пароль и подтверждение", title: "Ошибка")
                } else if newPassword.count < 8 {
                    self.showAlert(message: "Пароль не может быть менее 8 символов", title: "Ошибка")
                } else if newPassword != repeatPassword {
                    self.showAlert(message: "Пароль и его подтверждение должны совпадать", title: "Ошибка")
                } else {
                    guard let user = Auth.auth().currentUser else { return }
                    user.updatePassword(to: newPassword, completion: { [weak self] error in
                        guard let self = self else { return }
                        if let error = error {
                            self.showAlert(message: error.localizedDescription, title: "Ошибка")
                        } else {
                            self.showAlert(message: "Ваш пароль успешно изменён", title: "")
                        }
                    })
                }
            }))
            self.present(alert, animated: true, completion: nil)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
}
