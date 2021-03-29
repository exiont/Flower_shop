//
//  FSShopController.swift
//  Flower shop
//
//  Created by Eugene Hamitsevich on 3/21/21.
//

import UIKit
import SnapKit

struct Product {
    let image: UIImage?
    let name: String
    let description: String
}

class FSShopController: UIViewController, UITableViewDelegate {

    var products: [Product] = []

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

    private lazy var catalogSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Цветы","Букеты"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.cornerRadius = 5
        segmentedControl.tintColor = .black
        segmentedControl.backgroundColor = .white
        //        segmentedControl.addTarget(self, action: #selector(self.changeLoginOrRegiser(sender:)), for: .valueChanged)

        return segmentedControl
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        return searchBar
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.addSubview(logoImageView)
        self.view.addSubview(appLabel)
        self.view.addSubview(catalogSegmentedControl)
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        self.setupConstraints()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FSProductTableViewCell.self, forCellReuseIdentifier: FSProductTableViewCell.reuseIdentifier)
        self.updateProductsList()
        tableView.reloadData()

    }

    func updateProductsList() { // будет подгрузка из базы
        products.append(Product(image: nil, name: "Тюльпан", description: "Заморский"))
        products.append(Product(image: nil, name: "Хризантема", description: "Однолетняя"))
        products.append(Product(image: nil, name: "Роза", description: "Многолетняя"))
        products.append(Product(image: nil, name: "Свекла", description: "Добротная"))
        products.append(Product(image: nil, name: "Свежий", description: "Букет"))
        products.append(Product(image: nil, name: "Весенний", description: "Букетик"))
        products.append(Product(image: nil, name: "Праздничная", description: "Корзина"))
    }

    private func setupConstraints() {
        self.logoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }

        self.appLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.logoImageView.snp.bottom)
            make.left.right.equalToSuperview()
        }

        self.catalogSegmentedControl.snp.makeConstraints { (make) in
            make.top.equalTo(self.appLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(30)
        }

        self.searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(self.catalogSegmentedControl.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }

        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.searchBar.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
}

extension FSShopController: UISearchControllerDelegate, UISearchBarDelegate {

}

extension FSShopController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FSProductTableViewCell.reuseIdentifier, for: indexPath) as? FSProductTableViewCell,
              let placeholderImage = UIImage(named: "flower_placeholder")
        else {
            fatalError("No cell with this identifier")
        }

        let product = self.products[indexPath.row]
        cell.setCell(image: product.image ?? placeholderImage, name: product.name, description: product.description)

        return cell
    }

}
