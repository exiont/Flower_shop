//
//  FSShopController.swift
//  Flower shop
//
//  Created by Eugene Hamitsevich on 3/21/21.
//

import UIKit
import SnapKit

class FSShopController: FSViewController  {

    private var products: [FSProduct] = [] {
        didSet {
            self.filteredPdoructs = self.products
        }
    }

    private lazy var filteredPdoructs: [FSProduct] = self.products

    private lazy var filteredFlowersOrBouquet: [FSProduct] = self.products

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "flower_logo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var appLabel: FSLabel = {
        let label = FSLabel()
        label.text = "Цветочный магазин"
        label.textAlignment = .center
        label.font = UIFont.applyCustomFont(name: "Caveat-Regular", size: 30)

        return label
    }()

    private lazy var segmentedControlContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()

    private lazy var segmentedControl: FSSegmentedControl = {
        let segmentedControl = FSSegmentedControl(items: ["Цветы", "Букеты"])
        segmentedControl.addTarget(self, action: #selector(self.segmentedControlChangeValue), for: .valueChanged)
        segmentedControl.removeStyle()
        return segmentedControl
    }()

    private lazy var leftBottomUnderlineView: FSLineView = {
        let underlineView = FSLineView()
        return underlineView
    }()

    private lazy var rightBottomUnderlineView: FSLineView = {
        let underlineView = FSLineView()
        underlineView.isHidden = true
        return underlineView
    }()

    private lazy var searchBar: FSSearchBar = {
        let searchBar = FSSearchBar()
        searchBar.placeholder = "Поиск"
        searchBar.delegate = self

        return searchBar
    }()

    private lazy var tableView: FSTableView = {
        let tableView = FSTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FSProductTableViewCell.self, forCellReuseIdentifier: FSProductTableViewCell.reuseIdentifier)

        return tableView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.tintColor = FSColors.mainPink
        self.navigationController?.navigationBar.barTintColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        self.addSubbviews()
        self.setupConstraints()
        self.updateProductsList()

        self.products =  self.filteredFlowersOrBouquet.filter { !$0.isBouquet }
    }

    private func addSubbviews() {
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.appLabel)
        self.view.addSubview(self.segmentedControlContainerView)
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.tableView)
        self.segmentedControlContainerView.addSubview(self.segmentedControl)
        self.segmentedControlContainerView.addSubview(self.leftBottomUnderlineView)
        self.segmentedControlContainerView.addSubview(self.rightBottomUnderlineView)
    }

    private func updateProductsList() { // будет подгрузка из базы
        products.append(FSProduct(id: "001", image: nil, price: 5, name: "Тюльпан", description: "Заморский"))
        products.append(FSProduct(id: "002", image: nil, price: 7, name: "Хризантема", description: "Однолетняя"))
        products.append(FSProduct(id: "003", image: nil, price: 4, name: "Роза", description: "Многолетняя"))
        products.append(FSProduct(id: "004", image: nil, price: 9, name: "Свекла", description: "Добротная"))
        products.append(FSProduct(id: "005", image: nil, price: 10, name: "Свежий", description: "Букет", isBouquet: true))
        products.append(FSProduct(id: "006", image: nil, price: 12, name: "Весенний", description: "Букетик", isBouquet: true))
        products.append(FSProduct(id: "007", image: nil, price: 15, name: "Праздничная", description: "Корзина", isBouquet: true))
        products.append(FSProduct(id: "001", image: nil, price: 5, name: "Тюльпан", description: "Заморский"))
        products.append(FSProduct(id: "002", image: nil, price: 7, name: "Хризантема", description: "Однолетняя"))
        products.append(FSProduct(id: "003", image: nil, price: 4, name: "Роза", description: "Многолетняя"))
        products.append(FSProduct(id: "004", image: nil, price: 9, name: "Свекла", description: "Добротная"))
        products.append(FSProduct(id: "005", image: nil, price: 10, name: "Свежий", description: "Букет", isBouquet: true))
        products.append(FSProduct(id: "006", image: nil, price: 12, name: "Весенний", description: "Букетик", isBouquet: true))
        products.append(FSProduct(id: "007", image: nil, price: 15, name: "Праздничная", description: "Корзина", isBouquet: true))
        products.append(FSProduct(id: "001", image: nil, price: 5, name: "Тюльпан", description: "Заморский"))
        products.append(FSProduct(id: "002", image: nil, price: 7, name: "Хризантема", description: "Однолетняя"))
        products.append(FSProduct(id: "003", image: nil, price: 4, name: "Роза", description: "Многолетняя"))
        products.append(FSProduct(id: "004", image: nil, price: 9, name: "Свекла", description: "Добротная"))
        products.append(FSProduct(id: "005", image: nil, price: 10, name: "Свежий", description: "Букет", isBouquet: true))
        products.append(FSProduct(id: "006", image: nil, price: 12, name: "Весенний", description: "Букетик", isBouquet: true))
        products.append(FSProduct(id: "007", image: nil, price: 15, name: "Праздничная", description: "Корзина", isBouquet: true))
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
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }

        self.segmentedControl.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }

        self.leftBottomUnderlineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.segmentedControl.snp.bottom)
            make.left.equalTo(self.segmentedControl.snp.left)
            make.right.lessThanOrEqualTo(self.segmentedControl.snp.right).inset(self.view.frame.width / 2)
            make.width.equalTo(self.view.frame.width / 2)
        }

        self.rightBottomUnderlineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.segmentedControl.snp.bottom)
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
        self.searchBar.searchTextField.text = ""

        switch sender.selectedSegmentIndex {
        case 0:
            self.leftBottomUnderlineView.isHidden.toggle()
            self.rightBottomUnderlineView.isHidden.toggle()
            self.products = filteredFlowersOrBouquet.filter { !$0.isBouquet }
            self.tableView.reloadData()
        case 1:
            self.leftBottomUnderlineView.isHidden.toggle()
            self.rightBottomUnderlineView.isHidden.toggle()
            self.products = filteredFlowersOrBouquet.filter { $0.isBouquet }
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
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

extension FSShopController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.filteredPdoructs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FSProductTableViewCell.reuseIdentifier, for: indexPath) as? FSProductTableViewCell,
              let placeholderImage = UIImage(named: "flower_placeholder") else { fatalError("No cell with this identifier") }

        let product = self.filteredPdoructs[indexPath.row]
        cell.setCell(image: product.image ?? placeholderImage,
                     name: product.name,
                     description: product.description,
                     price: product.price)

        return cell
    }
}

extension FSShopController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = FSProductViewController()
        let product = products[indexPath.row]
        vc.loadData(product: product)
        navigationController?.pushViewController(vc, animated: true)
//        let navVC = UINavigationController(rootViewController: vc)
//        self.present(navVC, animated: true, completion: nil)
    }
}
