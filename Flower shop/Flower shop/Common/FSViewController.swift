//
//  FSViewController.swift
//  Flower shop
//
//  Created by New on 4.04.21.
//

import UIKit
import SnapKit

class FSViewController: UIViewController {

    var controllerTitle: String? {
        get {
            self.navigationItem.title
        }
        set {
            self.navigationItem.title = newValue
            self.navigationController?.navigationBar.backItem?.title = " "
        }
    }

    /// `false` if you don't want view to add automatic scrolling, when content is greater than visible view area.
    private var isContentScrollingEnabled: Bool = true

    private var heightMainViewConstraint: Constraint?

    private lazy var mainScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.contentInsetAdjustmentBehavior = .never
        scroll.backgroundColor = .clear

        return scroll
    }()

    private(set) lazy var mainView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self._initController()
        self.initController()
    }

    /// enables or disables content scrolling.
    /// - parameters:
    ///   - isEnabled: `true` scroll is enabled, `false` content is fixed. Default is `true`
    func setContentScrolling(isEnabled: Bool) {
        self.isContentScrollingEnabled = isEnabled
        self.mainView.snp.remakeConstraints { (make) in
            make.edges.width.equalToSuperview()
            if !isEnabled {
                self.heightMainViewConstraint = make.height.equalTo(self.mainScrollView).constraint
            }
        }
    }

    private func _initController() {
        self.view.backgroundColor = .white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        self.view.addSubview(self.mainScrollView)
        self.mainScrollView.addSubview(self.mainView)

        self.mainScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }

        self.mainView.snp.makeConstraints { (make) in
            make.edges.width.equalToSuperview()
        }

        self.setContentScrolling(isEnabled: true)
    }

    func initController() {}

    func showAlert(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func alertWithTitle(title: String, message: String, toFocus: UITextField) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel) { _ in
            toFocus.becomeFirstResponder()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
