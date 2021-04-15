//
//  FSAppCaller.swift
//  Flower shop
//
//  Created by New on 9.04.21.
//

import UIKit

class FSAppCaller {

    enum Maps {

        case googlemaps(latitude: Double, longitude: Double)
        case yandexmaps(latitude: Double, longitude: Double)
        case yandexnavi(latitude: Double, longitude: Double)

        var openUrls: (appScheme: String, url: String) {
            switch self {
            case .googlemaps(let coordinates):
                return ("comgooglemaps://",
                        "?saddr=&daddr=\(coordinates.latitude),\(coordinates.longitude)&directionsmode=driving")
            case .yandexmaps(let coordinates):
                return ("yandexmaps://",
                        "?whatshere[point]=\(coordinates.longitude),\(coordinates.latitude)&whatshere[zoom]=17")
            case .yandexnavi(let coordinates):
                return ("yandexnavi://",
                        "build_route_on_map?lat_to=\(coordinates.latitude)&lon_to=\(coordinates.longitude)")
            }
        }
    }

    enum SocialNetwork {
        case skype(id: String)
        case facebook(id: String)
        case tikTok(id: String)
        case instagram(id: String)
        case twitter(id: String)
        case youtube(id: String)
        case telegram(id: String)

        var openUrls: (appScheme: String?, url: String) {
            switch self {
            case .skype(let skype):
                return ("skype://\(skype)?call",
                        "https://apps.apple.com/us/app/skype-for-iphone/id304878510")
            case .facebook(let profileId):
                return ("fb://profile/\(profileId)",
                        "https://facebook.com/\(profileId)")
            case .tikTok(let profileId):
                return (nil, "https://vm.tiktok.com/\(profileId)")
            case .instagram(let profileId):
                return ("instagram://user?username=\(profileId)",
                        "https://www.instagram.com/\(profileId)")
            case .twitter(let profileId):
                return ("twitter://user?screen_name=\(profileId)",
                        "https://twitter.com/\(profileId)")
            case .youtube(let profileId):
                return ("youtube://\(profileId)",
                        "https://www.youtube.com/user/\(profileId)")
            case .telegram(let profileId):
                return ("tg://resolve?domain=\(profileId)",
                        "https://t.me/\(profileId)")
            }
        }
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

    class func open(socialNetwork: SocialNetwork) {
        let (appScheme, url) = socialNetwork.openUrls
        guard let scheme = appScheme, self.openUrl(scheme) else {
            self.openUrl(url)
            return
        }
    }

    class func canOpenMap(_ mapApp: Maps) -> Bool {
        let (appScheme, _) = mapApp.openUrls
        guard let scheme = URL(string: appScheme) else { return false }
        return UIApplication.shared.canOpenURL(scheme)
    }

    class func openMap(with mapApp: Maps){
        let (appScheme, url) = mapApp.openUrls
        self.openUrl(appScheme + url)
    }
}
