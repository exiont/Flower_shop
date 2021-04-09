//
//  FSAppCaller.swift
//  Flower shop
//
//  Created by New on 9.04.21.
//

import UIKit

class FSAppCaller {

    enum Maps: String {
        case googlemaps = "comgooglemaps://"
        case yandexmaps = "yandexmaps://"
        case yandexnavi = "yandexnavi://"
    }

    class func canOpenUrl(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    @discardableResult
    class func openUrl(_ urlString: String,
                       options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:],
                       completionHandler completion: ((Bool) -> Void)? = nil) -> Bool {
        guard let url = URL(string: urlString), self.canOpenUrl(urlString) else { return false }
        UIApplication.shared.open(url, options: options, completionHandler: completion)
        return true
    }

    class func openPhone(_ phone: String) {
        self.openUrl("tel://" + phone)
    }

    class func openGoogleMaps(latitude: Double, longitude: Double) {
        self.openUrl(Maps.googlemaps.rawValue + "?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving")
    }
}
