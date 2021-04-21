//
//  FSShopController.swift
//  Flower shop
//
//  Created by Eugene Hamitsevich on 3/21/21.
//

import UIKit
import SnapKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class FSShopController: FSViewController  {

    private var productsDatabase: [QueryDocumentSnapshot] = [] {
        didSet {
            self.filteredProducts = self.productsDatabase
        }
    }

    private lazy var filteredProducts: [QueryDocumentSnapshot] = self.productsDatabase
    private lazy var filteredFlowersOrBouquet: [QueryDocumentSnapshot] = self.productsDatabase

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

    private lazy var productTypeSegmentedControlView: FSSegmentedControlView = {
        let view = FSSegmentedControlView()
        view.segmentedControl.insertSegment(withTitle: "Цветы", at: 0, animated: false)
        view.segmentedControl.insertSegment(withTitle: "Букеты", at: 1, animated: false)
        view.segmentedControl.selectedSegmentIndex = 0
        view.segmentedControl.addTarget(self, action: #selector(self.segmentedControlChangeValue(sender:)), for: .valueChanged)
        return view
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        loadProductList()
        addSubbviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.tintColor = FSColors.mainPink
        self.navigationController?.navigationBar.barTintColor = .white
    }

    private func addSubbviews() {
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.appLabel)
        self.view.addSubview(self.productTypeSegmentedControlView)
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.tableView)
    }

    func loadProductList() {
        let db = Firestore.firestore()
        db.collection("products").getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            if let error = error {
                Swift.debugPrint(error.localizedDescription)
            } else if let snapshot = snapshot {
                self.productsDatabase = snapshot.documents
            }
            self.productsDatabase = self.filteredFlowersOrBouquet.filter { !($0.get("isBouquet") as? Bool ?? false) }
            self.tableView.reloadData()
        }
    }

    @objc private func segmentedControlChangeValue(sender: FSSegmentedControl) {
        self.searchBar.searchTextField.text = ""

        switch sender.selectedSegmentIndex {
        case 0:
            self.productTypeSegmentedControlView.leftBottomUnderlineView.isHidden.toggle()
            self.productTypeSegmentedControlView.rightBottomUnderlineView.isHidden.toggle()
            self.productsDatabase = filteredFlowersOrBouquet.filter { !($0.get("isBouquet") as? Bool ?? false) }
            self.tableView.reloadData()
        case 1:
            self.productTypeSegmentedControlView.leftBottomUnderlineView.isHidden.toggle()
            self.productTypeSegmentedControlView.rightBottomUnderlineView.isHidden.toggle()
            self.productsDatabase = filteredFlowersOrBouquet.filter { $0.get("isBouquet") as? Bool ?? false }
            self.tableView.reloadData()
        default:
            break
        }
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

        self.productTypeSegmentedControlView.snp.makeConstraints { (make) in
            make.top.equalTo(self.appLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }

        self.searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(self.productTypeSegmentedControlView.snp.bottom)
            make.left.right.equalToSuperview()
        }

        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        super.updateViewConstraints()
    }
}

extension FSShopController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredProducts = searchText.isEmpty
            ? self.productsDatabase
            : self.productsDatabase.filter { ($0.get("name") as? String ?? "").lowercased().contains(searchText.lowercased()) }
        self.tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
}

extension FSShopController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.filteredProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FSProductTableViewCell.reuseIdentifier, for: indexPath) as? FSProductTableViewCell else { return UITableViewCell() }

        let product = self.filteredProducts[indexPath.row]
        cell.setCell(productQuery: product)

        return cell
    }
}

extension FSShopController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = FSProductViewController()
        let product = FSProduct.parseProduct(productQuery: filteredProducts[indexPath.row])
        if let cell = tableView.cellForRow(at: indexPath) as? FSProductTableViewCell {
        product.image = cell.productImage
        }
        vc.loadData(product: product)
        navigationController?.pushViewController(vc, animated: true)
    }
}
