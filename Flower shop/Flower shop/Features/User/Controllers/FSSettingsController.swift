//
//  FSSettingsController.swift
//  Flower shop
//
//  Created by New on 14.04.21.
//

import UIKit

class FSSettingsController: FSViewController {
    var userInfo: FSUserInfo?

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

        case 2:
            let alert = UIAlertController(title: "", message: "Изменить e-mail", preferredStyle: .alert)

            alert.addTextField { (textField) in
                textField.placeholder = "Новый e-mail"
                textField.keyboardType = .emailAddress
            }
            alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { [weak alert] _ in
                guard let textfield = alert?.textFields?[0], let newEmail = textfield.text else { return }
                if newEmail.isEmpty || !newEmail.contains("@") || !newEmail.contains(".") {
                    self.showAlert(message: "Введен неправильный e-mail", title: "Ошибка!")
                } else {
                    self.userInfo?.email = newEmail
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
