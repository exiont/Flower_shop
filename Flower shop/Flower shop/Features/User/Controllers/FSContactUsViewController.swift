//
//  FSContactUsViewController.swift
//  Flower shop
//
//  Created by New on 16.04.21.
//

import UIKit

class FSContactUsViewController: FSViewController {

    private lazy var contactsTableView: FSTableView = {
        let tableView = FSTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FSContactUsCell.self, forCellReuseIdentifier: FSContactUsCell.reuseIdentifier)
        tableView.isScrollEnabled = false

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.contactsTableView)
    }

    override func updateViewConstraints() {

        self.contactsTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.greaterThanOrEqualToSuperview().inset(15)
        }

        super.updateViewConstraints()
    }

}

extension FSContactUsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.row {
        case 0:
            FSAppCaller.open(socialNetwork: .telegram(id: "@qqniq"))
        case 1:
            FSAppCaller.open(socialNetwork: .skype(id: "nizanizaz"))
        case 2:
            FSAppCaller.openPhone("+375291649033")
        default: break
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }

}

extension FSContactUsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: FSContactUsCell.reuseIdentifier, for: indexPath) as? FSContactUsCell else { return UITableViewCell() }

        switch indexPath.row {
        case 0:
            if let image = UIImage(named: "telegram_logo") {
                cell.setCell(image: image, title: "Telegram")
            }
        case 1:
            if let image = UIImage(named: "skype_logo") {
                cell.setCell(image: image, title: "Skype")
            }
        case 2:
            if let image = UIImage(named: "phone_logo") {
                cell.setCell(image: image, title: "Телефон")
            }
        default:
            break
        }
        cell.selectionStyle = .none

        return cell
    }
}
