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
    let isBouquet: Bool

    init(image: UIImage?, name: String, description: String, isBouquet: Bool = false) {
        self.image = image
        self.name = name
        self.description = description
        self.isBouquet = isBouquet
    }
}

class FSShopController: UIViewController  {

    private var products: [Product] = [] {
        didSet {
            self.filteredPdoructs = self.products
        }
    }

    private lazy var filteredPdoructs: [Product] = self.products


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
        let items: [String] = ["Цветы", "Букеты"]
        let segmentedControl = UISegmentedControl(items: items)
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
        searchBar.searchTextField.backgroundColor = UIColor(named: "white_pink")
        searchBar.searchTextField.layer.cornerRadius = 5
        searchBar.searchTextField.borderStyle = .none
        searchBar.searchTextField.layer.borderWidth = 0.5
        searchBar.searchTextField.layer.borderColor = UIColor(named: "main_pink")?.cgColor
        searchBar.searchTextField.textColor = UIColor(named: "brown_red")
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = UIColor(named: "main_pink")
        return searchBar
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = .white
        self.view.addSubview(logoImageView)
        self.view.addSubview(appLabel)
        self.view.addSubview(catalogSegmentedControl)
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        self.setupConstraints()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(FSProductTableViewCell.self, forCellReuseIdentifier: FSProductTableViewCell.reuseIdentifier)
        self.tableView.keyboardDismissMode = .onDrag
        self.searchBar.delegate = self
        self.updateProductsList()
        self.tableView.reloadData()
    }

    func updateProductsList() { // будет подгрузка из базы
        products.append(Product(image: nil, name: "Тюльпан", description: "Заморский"))
        products.append(Product(image: nil, name: "Хризантема", description: "Однолетняя"))
        products.append(Product(image: nil, name: "Роза", description: "Многолетняя"))
        products.append(Product(image: nil, name: "Свекла", description: "Добротная"))
        products.append(Product(image: nil, name: "Свежий", description: "Букет", isBouquet: true))
        products.append(Product(image: nil, name: "Весенний", description: "Букетик", isBouquet: true))
        products.append(Product(image: nil, name: "Праздничная", description: "Корзина", isBouquet: true))
        products.append(Product(image: nil, name: "Тюльпан", description: "Заморский"))
        products.append(Product(image: nil, name: "Хризантема", description: "Однолетняя"))
        products.append(Product(image: nil, name: "Роза", description: "Многолетняя"))
        products.append(Product(image: nil, name: "Свекла", description: "Добротная"))
        products.append(Product(image: nil, name: "Свежий", description: "Букет", isBouquet: true))
        products.append(Product(image: nil, name: "Весенний", description: "Букетик", isBouquet: true))
        products.append(Product(image: nil, name: "Праздничная", description: "Корзина", isBouquet: true))
        products.append(Product(image: nil, name: "Тюльпан", description: "Заморский"))
        products.append(Product(image: nil, name: "Хризантема", description: "Однолетняя"))
        products.append(Product(image: nil, name: "Роза", description: "Многолетняя"))
        products.append(Product(image: nil, name: "Свекла", description: "Добротная"))
        products.append(Product(image: nil, name: "Свежий", description: "Букет", isBouquet: true))
        products.append(Product(image: nil, name: "Весенний", description: "Букетик", isBouquet: true))
        products.append(Product(image: nil, name: "Праздничная", description: "Корзина", isBouquet: true))
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
            make.top.equalTo(self.catalogSegmentedControl.snp.bottom)
            make.left.right.equalToSuperview()
        }

        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

extension FSShopController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredPdoructs = searchText.isEmpty
            ? self.products
            : self.products.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        self.tableView.reloadData()
    }
}

extension FSShopController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.filteredPdoructs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FSProductTableViewCell.reuseIdentifier, for: indexPath) as? FSProductTableViewCell,
              let placeholderImage = UIImage(named: "flower_placeholder")
        else {
            fatalError("No cell with this identifier")
        }

        let product = self.filteredPdoructs[indexPath.row]
        cell.setCell(image: product.image ?? placeholderImage, name: product.name, description: product.description)

        return cell
    }
}

extension FSShopController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.present(FSProductViewController(), animated: true, completion: nil)
    }
}
