//
//  GoogleMapViewController.swift
//  Last.fm client
//
//  Created by student on 4/25/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import GoogleMaps

struct Location {
    let coord: CLLocationCoordinate2D
    let name: String
    
    init(coord: CLLocationCoordinate2D, name: String) {
        self.coord = coord
        self.name = name
    }
    
    init(name:String,lat:Double,lng:Double) {
        guard let latitude = CLLocationDegrees(exactly: lat),
              let longitude = CLLocationDegrees(exactly: lng) else {
                fatalError("Cant create coords")
        }
        
        coord = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
        self.name = name
    }
}

class GoogleMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var geoSwitch: UISwitch!
    @IBOutlet weak var locationSwitch: UISwitch!
    
    private let locationManager = CLLocationManager()
    private let geoService = GeoService()
    private let userDefaults = UserDefaultsService()
    private let marker = GMSMarker()
    private let defaultZoom: Float = 3.0
    private var currLocation: Location?
    var associatedTVC: ViewControllerForStorableData?
    
    lazy var countries = {
        return countriesCode.map({$0.value}).sorted { (str1, str2) in
            return str1 < str2
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        marker.map = mapView
        mapView.delegate = self
        countryPicker.delegate = self
        locationManager.delegate = self
        countryPicker.dataSource = self
        
        currLocation = userDefaults.getCurrCountry()
        geoSwitch.isOn = userDefaults.getGeoState()
        locationSwitch.isOn = userDefaults.getLocationState()
        updateCurrLocationState()
        
        if geoSwitch.isOn {
            updateCurrGeoState()
        } else if let location = currLocation {
            setPickerValue(location.name)
            marker.position = location.coord
            mapView.camera = GMSCameraPosition.camera(withTarget: location.coord, zoom: defaultZoom)
        } else {
            setCountry(withName: "United States")
            setPickerValue("United States")
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
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        marker.position = locValue
        marker.title = nil
        mapView.camera = GMSCameraPosition.camera(withTarget: locValue, zoom: defaultZoom)
        
        setCountry(byCoord: locValue)
    
    }
    
    // MARK: GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        marker.position = coordinate
        marker.title = nil
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
    
    @IBAction func changeGeoState(_ sender: UISwitch) {
        updateCurrGeoState()
    }
    
    @IBAction func changeLocationState(_ sender: UISwitch) {
        updateCurrLocationState()
        associatedTVC?.setData(viewsInfo: geoService.getLocationRelatedTop())
    }
    
    // MARK: Private Methods
    
    private func setCountry(withName name: String) {
        let fixedName = wrongNamesFix[name] ?? name
        guard let pair = countriesCode.first(where: {$0.value == fixedName}) else {
            fatalError("Cant find pair")
        }
        setUserPeekIsEnable(false)
        geoService.getCountry(byCode: pair.key) { data, error in
            self.marker.position = data
            self.marker.title = name
            self.mapView.camera = GMSCameraPosition.camera(withTarget: data, zoom: self.defaultZoom)
            
            let location = Location(coord: data, name: name)
            self.setLocationAndUpdateTVCIfNeeded(location)
            self.setUserPeekIsEnable(true)
        }
    }
    
    private func setCountry(byCoord coord: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        setUserPeekIsEnable(false)
        geocoder.reverseGeocodeCoordinate(coord) { data, err in
            
            let address = data?.firstResult()
            
            if var country = address?.country {
                country = wrongNamesFix[country] ?? country
                self.marker.title = country
                
                let location = Location(coord: coord, name: country)
                self.setLocationAndUpdateTVCIfNeeded(location)
                self.setPickerValue(country)
                self.setUserPeekIsEnable(true)
            }
        }
    }
    
    private func updateCurrLocationState() {
        if locationSwitch.isOn {
            geoSwitch.isEnabled = true
            setUserPeekIsEnable(true)
            userDefaults.saveLocationState(state: true)
            navigationItem.title = currLocation?.name
        } else {
            geoSwitch.isOn = false
            geoSwitch.isEnabled = false
            locationManager.stopUpdatingLocation()
            setUserPeekIsEnable(false)
            userDefaults.saveGeoState(state: false)
            userDefaults.saveLocationState(state: false)
            navigationItem.title = "World"
        }
    }
    
    private func updateCurrGeoState() {
        if geoSwitch.isOn {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            setUserPeekIsEnable(false)
            userDefaults.saveGeoState(state: true)
        } else {
            locationManager.stopUpdatingLocation()
            setUserPeekIsEnable(true)
            userDefaults.saveGeoState(state: false)
        }
    }
    
    private func setLocationAndUpdateTVCIfNeeded(_ location: Location) {
        userDefaults.saveCountry(location: location)
        if locationSwitch.isOn && currLocation?.name != location.name {
            navigationItem.title = location.name
            associatedTVC?.setData(viewsInfo: geoService.getLocationRelatedTop())
        }
        currLocation = location
    }
    
    private func setPickerValue(_ name: String) {
        if let id = countries.firstIndex(where: {$0 == name}) {
            countryPicker.selectRow(id, inComponent: 0, animated: true)
        } else {
            countryPicker.selectRow(0, inComponent: 0, animated: true)
        }
    }
    
    private func setUserPeekIsEnable(_ state: Bool) {
        mapView.isUserInteractionEnabled = state
        countryPicker.isUserInteractionEnabled = state
    }
}
