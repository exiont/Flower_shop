//
//  FSUser.swift
//  Flower shop
//
//  Created by New on 16.04.21.
//
import UIKit

class FSUserInfo {
    var email: String
    var name: String
    var address: String
    var avatar: UIImage?
    var orders: Int = 0
    var discount: Int {
        switch self.orders {
        case 0...1: return 0
        case 2...5: return 1
        case 6...10: return 5
        case 11...49: return 10
        default: return 15
        }
    }

    init(email: String = "", name: String = "", address: String = "", orders: Int = 0, avatar: UIImage? = nil) {
        self.email = email
        self.name = name
        self.address = address
        self.orders = orders
        self.avatar = avatar
    }
}
