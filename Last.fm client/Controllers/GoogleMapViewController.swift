//
//  GoogleMapViewController.swift
//  Last.fm client
//
//  Created by student on 4/25/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var geoSwitch: UISwitch!
    let locationManager = CLLocationManager()
    let marker = GMSMarker()
    let geoService = GeoService()
    let userDefaults = UserDefaultsService()
    
    private var currLocation: String! {
        didSet {
            navigationItem.title = currLocation
        }
    }
    
    lazy var countries = {
        return countriesCode.map({$0.value}).sorted { (str1, str2) in
            return str1 < str2
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        marker.map = mapView
        mapView.delegate = self
        countryPicker.dataSource = self
        countryPicker.delegate = self
        locationManager.delegate = self
        currLocation = userDefaults.getCurrCountry()
        geoSwitch.isOn = userDefaults.getGeoState()
        
        if currLocation == nil {
            setCountry(withName: "Belarus")
        } else {
            setCountry(withName: currLocation)
        }
        
        if geoSwitch.isOn {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
   
    static func getInstanceFromStoryboard() -> GoogleMapViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "MapController")
            as? GoogleMapViewController else {
                fatalError("Can't cast controller")
        }
        return controller
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        marker.position = locValue
        mapView.camera = GMSCameraPosition.camera(withTarget: locValue, zoom: 3.0)
        
        setCountry(byCoord: locValue)
    
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        marker.position = coordinate
        setCountry(byCoord: coordinate)
    }
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    
    // MARK: UIPickerViewDelegete
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setCountry(withName: countries[row])
    }
    
    // MARK: Actions
    
    @IBAction func changeState(_ sender: UISwitch) {
        if sender.isOn {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            userDefaults.saveGeoState(state: true)
        } else {
            locationManager.stopUpdatingLocation()
            userDefaults.saveGeoState(state: false)
        }
    }
    
    // MARK: Private Methods
    
    private func setCountry(withName name: String) {
        let geocoder = GMSGeocoder()
        
        guard let pair = countriesCode.first(where: {$0.value == name}) else {
            fatalError("Cant find pair")
        }
        
        geoService.getCountry(byCode: pair.key) { data, error in
            self.marker.position = data
            self.mapView.camera = GMSCameraPosition.camera(withTarget: data, zoom: 3.0)
            
            geocoder.reverseGeocodeCoordinate(data) { data, err in
                let address = data?.firstResult()
                self.marker.title = address?.country
                self.userDefaults.saveCountry(name: name)
                self.currLocation = name
            }
        }
    }
    
    private func setCountry(byCoord coord: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coord) { data, err in
            let address = data?.firstResult()
            if let country = address?.country {
                self.marker.title = country
                self.userDefaults.saveCountry(name: country)
                self.currLocation = country
            }
        }
    }
    
}
