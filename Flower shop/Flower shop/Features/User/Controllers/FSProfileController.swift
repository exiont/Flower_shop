//
//  FSProfileController.swift
//  Flower shop
//
//  Created by Eugene Hamitsevich on 3/22/21.
//

import UIKit
import SPStorkController
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseUI

class FSProfileController: FSViewController {

    // MARK: - Properties

    let profileImagePlaceholder: UIImage = UIImage(systemName: "person.circle") ?? UIImage()

    private var userInfo = FSUserInfo()
    private let avatarImageSize: CGSize = CGSize(width: 120, height: 120)
    private let edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

    // MARK: - GUI variables

    private lazy var profileLabel: FSLabel = {
        let label = FSLabel()
        label.text = "Профиль"
        label.textAlignment = .center
        label.font = UIFont.applyCustomFont(name: "Caveat-Regular", size: 30)

        return label
    }()

    private lazy var userProfileHeaderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addSubview(self.userAvatar)
        stackView.addSubview(self.userName)
        stackView.addSubview(self.userEmail)
        stackView.addSubview(self.userAddress)
        stackView.addSubview(self.userAddressLabel)
        stackView.addSubview(self.headerSeparatorView)

        return stackView
    }()

    private lazy var userAvatar: UIImageView = {
        let imageView = UIImageView()
        imageView.image = self.userInfo.avatar ?? self.profileImagePlaceholder
        imageView.tintColor = FSColors.mainPink
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = self.avatarImageSize.height / 2
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openImagePicker)))

        return imageView
    }()

    private lazy var userName: FSLabel = {
        let label = FSLabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        label.numberOfLines = 3
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75

        return label
    }()

    private lazy var userEmail: FSLabel = {
        let label = FSLabel()
        label.adjustsFontSizeToFitWidth = true

        return label
    }()

    private lazy var userAddress: FSLabel = {
        let label = FSLabel()

        return label
    }()

    private lazy var userAddressLabel: FSLabel = {
        let label = FSLabel()
        label.text = "Адрес доставки:"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)

        return label
    }()

    private lazy var headerSeparatorView: FSSeparatorView = {
        let view = FSSeparatorView()

        return view
    }()

    private lazy var userOrdersHistoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addSubview(self.ordersStackView)
        stackView.addSubview(self.discountStackView)
        stackView.addSubview(self.orderHistorySeparatorView)

        return stackView
    }()

    private lazy var ordersStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addSubview(self.userOrders)
        stackView.addSubview(self.userOrdersLabel)

        return stackView
    }()

    private lazy var userOrders: FSLabel = {
        let label = FSLabel()
        label.textAlignment = .center

        return label
    }()

    private lazy var userOrdersLabel: FSLabel = {
        let label = FSLabel()
        label.text = "Всего заказов"
        label.textAlignment = .center

        return label
    }()

    private lazy var discountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addSubview(self.userDiscount)
        stackView.addSubview(self.userDiscountLabel)

        return stackView
    }()

    private lazy var userDiscount: FSLabel = {
        let label = FSLabel()
        label.text = "\(self.userInfo.discount)%"
        label.textAlignment = .center

        return label
    }()

    private lazy var userDiscountLabel: FSLabel = {
        let label = FSLabel()
        label.text = "Скидка"
        label.textAlignment = .center

        return label
    }()

    private lazy var orderHistorySeparatorView: FSSeparatorView = {
        let view = FSSeparatorView()

        return view
    }()

    private lazy var menuTableView: FSTableView = {
        let tableView = FSTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FSProfileMenuCell.self, forCellReuseIdentifier: FSProfileMenuCell.reuseIdentifier)
        tableView.isScrollEnabled = false

        return tableView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        getUserData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.setUserData()
    }

    private func addSubviews() {
        self.view.addSubview(self.profileLabel)
        self.view.addSubview(self.userProfileHeaderStackView)
        self.view.addSubview(self.userOrdersHistoryStackView)
        self.view.addSubview(self.menuTableView)
    }

    // MARK: - Data setting methods

    private func setUserData() {
        self.userEmail.text = self.userInfo.email
        self.userName.text = self.userInfo.name
        self.userAddress.text = self.userInfo.address
        self.userOrders.text = String(self.userInfo.orders)
        self.userDiscount.text = "\(self.userInfo.discount)%"
    }

    private func getUserData() {
        guard let user = Auth.auth().currentUser else { return }
        let storageReference = Storage.storage().reference().child("users/\(user.uid)")
        self.userInfo.name = user.displayName ?? ""
        self.userName.text = user.displayName
        self.userInfo.email = user.email ?? ""
        storageReference.getMetadata { (metadata: StorageMetadata?, error) in
            if let error = error {
                Swift.debugPrint(error.localizedDescription)
            } else {
                guard let metadata = metadata else {
                    self.userAvatar.image = self.profileImagePlaceholder
                    return
                }

                if metadata.isFile {
                    self.userAvatar.sd_setImage(with: storageReference)
                } else {
                    self.userAvatar.image = self.profileImagePlaceholder
                }
            }
        }

        self.loadUserAddress()
        self.loadUserOrdersHistory()
    }

    private func loadUserAddress() {
        guard let user = Auth.auth().currentUser else { return }
        let addresses = Firestore.firestore().collection("addresses")
        let userAddress = addresses.document(user.uid)
        userAddress.getDocument { (document, error) in
            if let document = document, document.exists {
                if let address = document.get("address") as? String {
                    self.userInfo.address = address
                    self.userAddress.text = address
                }
            } else if let error = error {
                self.showAlert(message: error.localizedDescription, title: "Ошибка")
            }
        }
    }

    private func loadUserOrdersHistory() {
        guard let user = Auth.auth().currentUser else { return }
        let allUsersOrders = Firestore.firestore().collection("orders")
        let userOrders = allUsersOrders.document(user.uid)
        userOrders.addSnapshotListener(includeMetadataChanges: true) { (ordersSnapshot, error) in
            if let error = error {
                Swift.debugPrint(error.localizedDescription)
            } else if let orders = ordersSnapshot {
                self.userInfo.orders = orders.data()?.count ?? 0
                self.userOrders.text = String(self.userInfo.orders)
                self.userDiscount.text = "\(self.userInfo.discount)%"
            }
        }
    }

    func getDiscount() -> Int {
        self.userInfo.discount
    }

    @objc func openImagePicker() {

        let alert = UIAlertController(title: "Выберите изображение профиля", message: nil, preferredStyle: .actionSheet)
        let galleryAction = UIAlertAction(title: "Открыть галерею", style: .default) { UIAlertAction in
            let picker = UIImagePickerController()
            picker.mediaTypes = ["public.image"]
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }

        let cameraAction = UIAlertAction(title: "Сделать фото", style: .default) { UIAlertAction in
            let picker = UIImagePickerController()
            picker.mediaTypes = ["public.image"]
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }

        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)

        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
            guard let scene = UIApplication.shared.connectedScenes.first,
                  let sceneDelegate = scene.delegate as? SceneDelegate else { return }
            let authVC = FSAuthorizationController()
            sceneDelegate.changeRootViewConroller(authVC)
        } catch {
            showAlert(message: "Ошибка выхода: \(error.localizedDescription)", title: "Ошибка")
        }
    }

    //MARK: - Constraints setup

    override func updateViewConstraints() {

        self.profileLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }

        self.userProfileHeaderStackView.snp.makeConstraints { (make) in
            make.top.equalTo(self.profileLabel.snp.bottom)
            make.left.right.equalToSuperview()
        }

        self.userAvatar.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(10)
            make.size.equalTo(self.avatarImageSize)
        }

        self.userName.snp.makeConstraints { (make) in
            make.top.lessThanOrEqualTo(self.userAvatar.snp.top).offset(20)
            make.left.equalTo(self.userAvatar.snp.right).offset(10)
            make.right.equalToSuperview()
        }

        self.userEmail.snp.makeConstraints { (make) in
            make.left.equalTo(self.userName)
            make.top.equalTo(self.userName.snp.bottom).offset(5)
            make.right.equalToSuperview()
            make.bottom.lessThanOrEqualTo(self.userAvatar)

        }

        self.userAddressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.userAvatar.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(self.edgeInsets)
        }

        self.userAddress.snp.makeConstraints { (make) in
            make.top.equalTo(self.userAddressLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(self.edgeInsets)
            make.bottom.equalTo(self.headerSeparatorView.snp.top).offset(-5)
        }

        self.headerSeparatorView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }

        self.userOrdersHistoryStackView.snp.makeConstraints { (make) in
            make.top.equalTo(self.userProfileHeaderStackView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
        }

        self.ordersStackView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            make.bottom.equalTo(self.orderHistorySeparatorView.snp.top).offset(-5)
        }

        self.userOrders.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }

        self.userOrdersLabel.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.userOrders.snp.bottom)
        }

        self.discountStackView.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.left.equalTo(self.ordersStackView.snp.right)
            make.bottom.equalTo(self.ordersStackView)
        }

        self.userDiscount.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }

        self.userDiscountLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.userDiscount.snp.bottom)
        }

        self.orderHistorySeparatorView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }

        self.menuTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.userOrdersHistoryStackView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(self.edgeInsets)
            make.bottom.greaterThanOrEqualToSuperview()
        }

        super.updateViewConstraints()
    }
}

//MARK: - Extensions

extension FSProfileController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FSProfileMenuCell.reuseIdentifier, for: indexPath) as? FSProfileMenuCell else { return UITableViewCell() }

        switch indexPath.row {
        case 0:
            if let image = UIImage(systemName: "slider.horizontal.3") {
                cell.setCell(image: image, title: "Настройки")
            }
        case 1:
            if let image = UIImage(systemName: "arrowshape.turn.up.backward") {
                cell.setCell(image: image, title: "Выйти из профиля")
            }
        case 2:
            if let image = UIImage(systemName: "phone.bubble.left") {
                cell.setCell(image: image, title: "Связаться с нами")
            }
        default:
            break
        }
        cell.selectionStyle = .none

        return cell
    }
}

extension FSProfileController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.row {
        case 0:
            let vc = FSSettingsController()
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            self.logout()
        case 2:
            let vc = FSContactUsViewController()
            let transitionDelegate = SPStorkTransitioningDelegate()
            vc.transitioningDelegate = transitionDelegate
            vc.modalPresentationStyle = .custom
            vc.modalPresentationCapturesStatusBarAppearance = true
            transitionDelegate.customHeight = 160
            transitionDelegate.indicatorColor = FSColors.mainPink
            transitionDelegate.indicatorMode = .alwaysLine
            transitionDelegate.translateForDismiss = 80
            self.present(vc, animated: true, completion: nil)
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
}

//MARK: - Image picker delegate

extension FSProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        guard let user = Auth.auth().currentUser,
              let image = info[.editedImage] as? UIImage,
              let data = image.jpegData(compressionQuality: 0.5) else {
            self.userAvatar.image = info[.originalImage] as? UIImage
            return
        }

        let metadata = StorageMetadata()

        let storageReference = Storage.storage().reference().child("users/\(user.uid)")
        storageReference.putData(data, metadata: metadata) { (metadata, error) in
            if error == nil {
                storageReference.downloadURL { (url, error) in
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.photoURL = url
                    changeRequest.commitChanges { (error) in
                        if let error = error {
                        self.showAlert(message: error.localizedDescription, title: "Загрузка")
                        } else {
                            Swift.debugPrint("Изображение загружено, Url: \(String(describing: url))")
                        }
                    }
                }
            } else {
                Swift.debugPrint("Ошибка \(String(describing: error))")
            }
        }

        self.userAvatar.image = image
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Delegating to the settings controller

extension FSProfileController: FSSettingsControllerDelegate {

    func updateUserAddress(with address: String) {
        self.userInfo.address = address
        self.setUserData()
    }

    func updateUserEmail(with email: String) {
        self.userInfo.email = email
        self.setUserData()
    }

    func updateUserName(with name: String) {
        self.userInfo.name = name
        self.setUserData()
    }
}
