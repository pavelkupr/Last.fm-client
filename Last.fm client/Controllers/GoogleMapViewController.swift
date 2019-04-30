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
    
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var geoSwitch: UISwitch!
    
    private let locationManager = CLLocationManager()
    private let geoService = GeoService()
    private let userDefaults = UserDefaultsService()
    private let apiService = APIService()
    private let marker = GMSMarker()
    private let defaultZoom: Float = 3.0
    
    var associatedTVC: ViewControllerForStorableData?
    
    private var currLocation: Location? {
        didSet {
            navigationItem.title = currLocation?.name
            if let location = currLocation {
            associatedTVC?.setData(viewsInfo: [
                TableViewInfo(data: [], navName: "Top Artists", dataSource: apiService.getTopArtistsClosure(byCountry: location.name)),
                TableViewInfo(data: [], navName: "Top Tracks", dataSource: apiService.getTopTracksClosure(byCountry: location.name))])
            }
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
        
        if geoSwitch.isOn {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else if let location = currLocation {
            marker.position = location.coord
            mapView.camera = GMSCameraPosition.camera(withTarget: location.coord, zoom: defaultZoom)
        } else {
            setCountry(withName: "Belarus")
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
        marker.title = nil
        mapView.camera = GMSCameraPosition.camera(withTarget: locValue, zoom: defaultZoom)
        
        setCountry(byCoord: locValue)
    
    }
    
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
        let fixedName = errorNames[name] ?? name
        guard let pair = countriesCode.first(where: {$0.value == fixedName}) else {
            fatalError("Cant find pair")
        }
        
        geoService.getCountry(byCode: pair.key) { data, error in
            self.marker.position = data
            self.marker.title = name
            self.mapView.camera = GMSCameraPosition.camera(withTarget: data, zoom: self.defaultZoom)
            
            let location = Location(coord: data, name: name)
            self.userDefaults.saveCountry(location: location)
            self.currLocation = location
        }
    }
    
    private func setCountry(byCoord coord: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coord) { data, err in
            
            let address = data?.firstResult()
            
            if var country = address?.country {
                country = errorNames[country] ?? country
                self.marker.title = country
                
                let location = Location(coord: coord, name: country)
                self.userDefaults.saveCountry(location: location)
                self.currLocation = location
            }
        }
    }
    
}
