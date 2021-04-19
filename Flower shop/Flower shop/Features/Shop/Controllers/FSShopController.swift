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
    private var productsDatabase: [QueryDocumentSnapshot] = []

    private var products: [FSProduct] = [] {
        didSet {
            self.filteredProducts = self.products
        }
    }

    private lazy var filteredProducts: [FSProduct] = self.products

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.tintColor = FSColors.mainPink
        self.navigationController?.navigationBar.barTintColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.loadProductList()
        self.addSubbviews()
        self.setupConstraints()
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
            if let error = error {
                Swift.debugPrint(error.localizedDescription)
            } else if let snapshot = snapshot {
                self?.productsDatabase = snapshot.documents
                }
            }
//            self.products = self.filteredFlowersOrBouquet.filter { !$0.isBouquet }
//            self.tableView.reloadData()
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
    }

    @objc private func segmentedControlChangeValue(sender: FSSegmentedControl) {
        self.searchBar.searchTextField.text = ""

        switch sender.selectedSegmentIndex {
        case 0:
            self.productTypeSegmentedControlView.leftBottomUnderlineView.isHidden.toggle()
            self.productTypeSegmentedControlView.rightBottomUnderlineView.isHidden.toggle()
            self.products = filteredFlowersOrBouquet.filter { !$0.isBouquet }
            self.tableView.reloadData()
        case 1:
            self.productTypeSegmentedControlView.leftBottomUnderlineView.isHidden.toggle()
            self.productTypeSegmentedControlView.rightBottomUnderlineView.isHidden.toggle()
            self.products = filteredFlowersOrBouquet.filter { $0.isBouquet }
            self.tableView.reloadData()
        default:
            break
        }
    }
}

extension FSShopController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredProducts = searchText.isEmpty
            ? self.products
            : self.products.filter { $0.name.lowercased().contains(searchText.lowercased()) }
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
        self.productsDatabase.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FSProductTableViewCell.reuseIdentifier, for: indexPath) as? FSProductTableViewCell else { return UITableViewCell() }

        let product = self.productsDatabase[indexPath.row]
        cell.setCellFromDB(productQuery: product)
        return cell
    }
}

extension FSShopController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = FSProductViewController()
        let product = FSProduct.parseProduct(productQuery: productsDatabase[indexPath.row])
        vc.loadData(product: product)
        navigationController?.pushViewController(vc, animated: true)
    }
}
