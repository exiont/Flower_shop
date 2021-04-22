//
//  FSOrder.swift
//  Flower shop
//
//  Created by New on 20.04.21.
//

import Foundation

class FSOrder {
    var totalPrice: Double
    var address: String
    var phoneNumber: String
    var paymentMethod: String
    var pickupPoint: Int
    var orderedProducts: [String: Int]
    var isСourierDelivery: Bool
    var date: String

    init(isСourierDelivery: Bool, orderProducts: [String: Int], totalPrice: Double, address: String, phoneNumber: String, paymentMethod: String, date: String) {
        self.isСourierDelivery = isСourierDelivery
        self.orderedProducts = orderProducts
        self.totalPrice = totalPrice
        self.address = address
        self.phoneNumber = phoneNumber
        self.paymentMethod = paymentMethod
        self.date = date
        self.pickupPoint = 0
    }

    init(isСourierDelivery: Bool, orderProducts: [String: Int], totalPrice: Double, phoneNumber: String, pickupPoint: Int, date: String) {
        self.isСourierDelivery = isСourierDelivery
        self.orderedProducts = orderProducts
        self.totalPrice = totalPrice
        self.phoneNumber = phoneNumber
        self.pickupPoint = pickupPoint
        self.date = date
        self.address = ""
        self.paymentMethod = ""
    }
}
