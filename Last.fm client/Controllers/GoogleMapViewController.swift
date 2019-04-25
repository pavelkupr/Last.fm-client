//
//  GoogleMapViewController.swift
//  Last.fm client
//
//  Created by student on 4/25/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleMapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    let marker = GMSMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        marker.map = mapView
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            marker.position = CLLocationCoordinate2D(latitude: 53.9, longitude: 27.56667)
            mapView.camera = GMSCameraPosition.camera(withLatitude: 53.9, longitude: 27.56667, zoom: 6.0)
            marker.title = "Minsk"
            marker.snippet = "Belarus"
        }
    }
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geocoder = GMSGeocoder()
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        marker.position = locValue
        mapView.camera = GMSCameraPosition.camera(withTarget: locValue, zoom: 6.0)
        
        geocoder.reverseGeocodeCoordinate(locValue) { data, err in
            let address = data?.firstResult()
            self.marker.title = address?.country
        }
    
    }
}
