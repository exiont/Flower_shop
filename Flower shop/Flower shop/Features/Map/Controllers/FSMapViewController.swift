//
//  FSMapViewController.swift
//  Flower shop
//
//  Created by Eugene Hamitsevich on 4/3/21.
//

import UIKit
import GoogleMaps

class FSMapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!

    private let locationManager = CLLocationManager()

    private var markets: [FSMarket] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureMap()
        self.loadMarkets()
        self.createMarketsMarkers()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func configureMap() {
        self.mapView.delegate = self
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.compassButton = true
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }

    private func loadMarkets() { // будет подгрузка из базы
        let firstMarket = FSMarket(latitude: 53.90, longitude: 27.62, name: "Flower shop 1", workingHours: "08:00 - 23:00", description: "Тракторный завод")
        let secondMarket = FSMarket(latitude: 53.92, longitude: 27.62, name: "Flower shop 2", workingHours: "09:00 - 21:00", description: "Московская")
        let thirdMarket = FSMarket(latitude: 53.94, longitude: 27.63, name: "Flower shop 2", workingHours: "24/7", description: "Зелёный луг")

        self.markets.append(contentsOf: [firstMarket, secondMarket, thirdMarket])
    }

    private func createMarketsMarkers() {
        self.mapView.clear()

        var markers: [GMSMarker] = []

        for market in markets {
            let marker = GMSMarker()
            let latitude = market.latitude
            let longitude = market.longitude
            if let latitude = latitude, let longitude = longitude {
                marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }
            marker.map = mapView
            marker.userData = market
            marker.isTappable = true
            markers.append(marker)
        }

        // отцентровать камеру!
        if let firstPosition = markers.first?.position {
            var bounds = GMSCoordinateBounds(coordinate: firstPosition, coordinate: firstPosition)
            for marker in markers {
                let currentBounds = GMSCoordinateBounds(coordinate: marker.position, coordinate: marker.position)
                bounds = bounds.includingBounds(currentBounds)
            }
            let positionUpdate = GMSCameraUpdate.fit(bounds, withPadding: 150)
            self.mapView.animate(with: positionUpdate)
        }
    }
}

extension FSMapViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {

        guard let market = marker.userData as? FSMarket else { return false }

        if let latitude = market.latitude, let longitude = market.longitude, let description = market.description, let workingHours = market.workingHours {

            let message = "\(description)\nВремя работы: \(workingHours)"
            let title = market.name
            let backAction = UIAlertAction(title: "Отменить", style: .cancel)
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

            let latitude = latitude
            let longitude = longitude

            let isGoogleMapsAvailable: Bool = UIApplication.shared.canOpenURL(URL.init(string: "comgooglemaps://")!)
            if isGoogleMapsAvailable {
                let googleMapsAction = UIAlertAction(title: "Google Maps", style: .default) { _ in
                    guard let url = URL.init(string: "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving") else { return }
                    UIApplication.shared.open(url)
                }
                alert.addAction(googleMapsAction)
            }

            let isYandexMapsAvailable: Bool = UIApplication.shared.canOpenURL(URL.init(string: "yandexmaps://")!)
            if isYandexMapsAvailable {
                let yandexMapsAction = UIAlertAction(title: "Yandex maps", style: .default) { _ in
                    guard let coordinate = self.mapView.myLocation else { return }
                    guard let url = URL.init(string: "yandexmaps://maps.yandex.com/?rtext=\(coordinate.coordinate.latitude),\(coordinate.coordinate.longitude)~\(latitude),\(longitude)") else { return }
                    UIApplication.shared.open(url)
                }
                alert.addAction(yandexMapsAction)
            }

            let isYandexNavigatorAvailable: Bool = UIApplication.shared.canOpenURL(URL.init(string: "yandexnavi://")!)
            if isYandexNavigatorAvailable {
                let yandexNavigatorAction = UIAlertAction(title: "Yandex navigator", style: .default) { _ in
                    guard let url = URL.init(string: "yandexnavi://build_route_on_map?lat_to=\(latitude)&lon_to=\(longitude)") else { return }
                    UIApplication.shared.open(url)
                }
                alert.addAction(yandexNavigatorAction)
            }

            alert.addAction(backAction)

            self.present(alert, animated: true, completion: nil)
        }
        return true
    }
}

extension FSMapViewController: CLLocationManagerDelegate {

}
