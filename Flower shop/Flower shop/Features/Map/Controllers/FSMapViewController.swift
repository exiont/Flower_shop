//
//  FSMapViewController.swift
//  Flower shop
//
//  Created by Eugene Hamitsevich on 4/3/21.
//

import UIKit
import GoogleMaps

class FSMapViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var mapView: GMSMapView!

    // MARK: - Properties

    private let locationManager = CLLocationManager()
    private var markets: [FSMarket] = []
    private var markers: [GMSMarker] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureMap()
        loadMarkets()
        createMarketsMarkers()
        centerCamera()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Map configuring methods

    private func configureMap() {
        self.mapView.delegate = self
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.compassButton = true
        self.locationManager.requestWhenInUseAuthorization()
    }

    private func loadMarkets() { // TODO: markets info loading from database
        let firstMarket = FSMarket(latitude: 53.90, longitude: 27.62, name: "Магазин 1", workingHours: "10:00 - 21:00", description: "Тракторный завод")
        let secondMarket = FSMarket(latitude: 53.92, longitude: 27.62, name: "Магазин 2", workingHours: "08:00 - 00:00", description: "Московская")
        let thirdMarket = FSMarket(latitude: 53.94, longitude: 27.63, name: "Магазин 3", workingHours: "09:00 - 22:00", description: "Зелёный луг")

        self.markets.append(contentsOf: [firstMarket, secondMarket, thirdMarket])
    }

    private func createMarketsMarkers() {
        self.mapView.clear()

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
            self.markers.append(marker)
        }
    }

    private func centerCamera() {
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

// MARK: - Extensions

extension FSMapViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {

        guard let market = marker.userData as? FSMarket else { return false }

        if let latitude = market.latitude,
           let longitude = market.longitude,
           let description = market.description,
           let workingHours = market.workingHours {

            let message = "\(description)\nВремя работы: \(workingHours)"
            let title = market.name
            let backAction = UIAlertAction(title: "Отменить", style: .cancel)
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

            let latitude = latitude
            let longitude = longitude

            let yandexmaps = FSAppCaller.Maps.yandexmaps(latitude: latitude, longitude: longitude)
            let yandexnavi = FSAppCaller.Maps.yandexnavi(latitude: latitude, longitude: longitude)
            let googlemaps = FSAppCaller.Maps.googlemaps(latitude: latitude, longitude: longitude)

            //TODO: make switch instead of if

            if FSAppCaller.canOpenMap(yandexmaps) {
                let yandexMapsAction = UIAlertAction(title: "Яндекс.Карты", style: .default) { _ in
                    FSAppCaller.openMap(with: yandexmaps)
                }
                alert.addAction(yandexMapsAction)
            }

            if FSAppCaller.canOpenMap(yandexnavi) {
                let yandexNavigatorAction = UIAlertAction(title: "Яндекс.Навигатор", style: .default) { _ in
                    FSAppCaller.openMap(with: yandexnavi)
                }
                alert.addAction(yandexNavigatorAction)
            }

            if FSAppCaller.canOpenMap(googlemaps) {
                let googleMapsAction = UIAlertAction(title: "Google Maps", style: .default) { _ in
                    FSAppCaller.openMap(with: googlemaps)
                }
                alert.addAction(googleMapsAction)
            }

            alert.addAction(backAction)

            self.present(alert, animated: true, completion: nil)
        }

        return true
    }
}
