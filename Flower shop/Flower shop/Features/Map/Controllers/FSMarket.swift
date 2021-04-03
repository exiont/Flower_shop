//
//  FSMarket.swift
//  Flower shop
//
//  Created by Eugene Hamitsevich on 4/3/21.
//

import Foundation

class FSMarket {

    var latitude: Double?
    var longitude: Double?
    var workingHours: String?
    var name: String?
    var description: String?
    var address: String?

    init(latitude: Double, longitude: Double, name: String, workingHours: String, description: String) {
        self.workingHours = workingHours
        self.name = name
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
    }

//    init() {}

}
