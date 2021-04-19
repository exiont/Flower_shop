//
//  FSProduct.swift
//  Flower shop
//
//  Created by New on 7.04.21.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class FSProduct {
    var id: Int
    var isBouquet: Bool
    var price: Double
    var imageUrl: String
    var name: String
    var description: String
    var details: String
    var imageView: UIImageView? = UIImageView()
    var image: UIImage? {
        self.imageView?.image
    }

    init(id: Int = 0, image: String = "", price: Double = 0, name: String = "", description: String = "", details: String = "", isBouquet: Bool = false) {
        self.id = id
        self.isBouquet = isBouquet
        self.price = price
        self.imageUrl = image
        self.name = name
        self.description = description
        self.details = details
    }

    static func parseProduct(productQuery: QueryDocumentSnapshot) -> FSProduct {
        let product = FSProduct()
        product.id = productQuery.get("id") as? Int ?? 0
        product.isBouquet = productQuery.get("isBouquet") as? Bool ?? false
        product.price = productQuery.get("price") as? Double ?? 0
        product.name = productQuery.get("name") as? String ?? ""
        product.description = productQuery.get("description") as? String ?? ""
        product.details = productQuery.get("details") as? String ?? ""
        product.imageUrl = productQuery.get("image") as? String ?? ""

        let imagePath = product.imageUrl
        if !imagePath.isEmpty {
            let storageRef = Storage.storage().reference()
            let reference = storageRef.child(imagePath)
            product.imageView?.sd_setImage(with: reference)
        }
        return product
    }
}
