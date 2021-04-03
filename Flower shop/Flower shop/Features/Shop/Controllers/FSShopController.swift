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

    private lazy var filteredFlowersOrBouquet: [Product] = self.products

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

    private lazy var segmentedControlContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()

    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "Цветы", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Букеты", at: 1, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = .clear
        segmentedControl.backgroundColor = .clear
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "brown_red") ?? .systemPink,
                                                 NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "brown_red") ?? .systemPink,
                                                 NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)], for: .selected)
        segmentedControl.addTarget(self, action: #selector(self.segmentedControlChangeValue), for: .valueChanged)
        segmentedControl.removeStyle()
        return segmentedControl
    }()

    private lazy var leftBottomUnderlineView: UIView = {
        let underlineView = UIView()
        underlineView.backgroundColor = UIColor(named: "main_pink")
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        return underlineView
    }()

    private lazy var rightBottomUnderlineView: UIView = {
        let underlineView = UIView()
        underlineView.backgroundColor = UIColor(named: "main_pink")
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.isHidden = true
        return underlineView
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
        self.addSubbviews()
        self.setupConstraints()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(FSProductTableViewCell.self, forCellReuseIdentifier: FSProductTableViewCell.reuseIdentifier)
        self.tableView.keyboardDismissMode = .onDrag
        self.searchBar.delegate = self
        self.updateProductsList()
        self.tableView.reloadData()
        self.products =  self.filteredFlowersOrBouquet.filter { !$0.isBouquet }
    }

    func addSubbviews() {
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.appLabel)
        self.view.addSubview(self.segmentedControlContainerView)
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.tableView)
        self.segmentedControlContainerView.addSubview(self.segmentedControl)
        self.segmentedControlContainerView.addSubview(self.leftBottomUnderlineView)
        self.segmentedControlContainerView.addSubview(self.rightBottomUnderlineView)
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

        self.segmentedControlContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.appLabel.snp.bottom).offset(5)
            make.width.equalTo(self.view.frame.width)
            make.height.equalTo(40)
        }

        self.segmentedControl.snp.makeConstraints { (make) in
            make.top.equalTo(self.segmentedControlContainerView.snp.top)
//            make.center.equalTo(self.segmentedControlContainerView)
            make.left.right.equalToSuperview()
        }

        self.leftBottomUnderlineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.segmentedControl.snp.bottom)
            make.height.equalTo(1)
            make.left.equalTo(self.segmentedControl.snp.left)
            make.right.lessThanOrEqualTo(self.segmentedControl.snp.right).inset(self.view.frame.width / 2)
            make.width.equalTo(self.view.frame.width / 2)
        }

        self.rightBottomUnderlineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.segmentedControl.snp.bottom)
            make.height.equalTo(1)
            make.right.equalTo(self.segmentedControl.snp.right)
            make.left.lessThanOrEqualTo(self.segmentedControl.snp.left).inset(self.view.frame.width / 2)
            make.width.equalTo(self.view.frame.width / 2)
        }

        self.searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(self.segmentedControlContainerView.snp.bottom)
            make.left.right.equalToSuperview()
        }

        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }

    @objc private func segmentedControlChangeValue(sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            self.leftBottomUnderlineView.isHidden.toggle()
            self.rightBottomUnderlineView.isHidden.toggle()
            self.products =  filteredFlowersOrBouquet.filter { !$0.isBouquet }
            self.tableView.reloadData()
        case 1:
            self.leftBottomUnderlineView.isHidden.toggle()
            self.rightBottomUnderlineView.isHidden.toggle()
            self.products =  filteredFlowersOrBouquet.filter { $0.isBouquet }
            self.tableView.reloadData()
        default:
            break
        }
    }

    private func changeSegmentedControlLinePositionAnimated() { // сделать анимацию перезда подчёркивания
//        let segmentIndex = CGFloat(self.segmentedControl.selectedSegmentIndex)
//        let segmentWidth = self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)
//        let leadingDistance = segmentWidth * segmentIndex
//        UIView.animate(withDuration: 0.3, animations: { [weak self] in
//            self?.leftBottomUnderlineView.snp.makeConstraints({ (make) in
//                guard let self = self else { return }
//                make.left.equalTo(self.segmentedControl.snp.left).offset(leadingDistance)
//            })
//        })
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
