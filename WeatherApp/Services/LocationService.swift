//
//  LocationService.swift
//  WeatherApp
//
//  Created by Nikolay Mikhaylov on 09.09.2021.
//

import Foundation
import CoreLocation
import UIKit

class LocationService: NSObject, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    
    private var locationSaved: CLLocation? {
        get {
            UserDefaults.standard.location(forKey: UserDefaultsKeys.locationSaved)
        }
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.locationSaved)
            } else {
                UserDefaults.standard.set(location: newValue!, forKey: UserDefaultsKeys.locationSaved)
            }
        }
    }
    public var manualAsk = false
    public var currentLocationLat: Float? {
        if let lat = currentLocation?.coordinate.latitude {
            return Float(lat)
        }
        return nil
    }
    public var currentLocationLon: Float? {
        if let lon = currentLocation?.coordinate.longitude {
            return Float(lon)
        }
        return nil
    }
    
    public var locationInProgress: Bool {
        if locationManager.authorizationStatus == .authorizedAlways ||
           locationManager.authorizationStatus == .authorizedWhenInUse {
            return true
        } else {
            return false
           
        }
    }
    
    public var currentLocation: CLLocation? {
        get {
           return locationSaved
        }
        set {
            self.locationSaved = newValue
        }
    }
    public var errorGetAuthorizationStatus: (() -> Void)?
    public var currentLocationWasSet: (() -> Void)?
   
    override init() {
        super.init()
        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    public func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            errorGetAuthorizationStatus?()
        case .denied:
            errorGetAuthorizationStatus?()
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            print("Location status is OK.")
        @unknown default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        currentLocation = location
        currentLocationWasSet?()
        locationManager.stopUpdatingLocation()
    }
}
extension Locale {
    static var getPreferredLocale: Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
    }
}
extension UserDefaults {
    
    func set(location: CLLocation, forKey key: String) {
        let locationLat = NSNumber(value: location.coordinate.latitude)
        let locationLon = NSNumber(value: location.coordinate.longitude)
        self.set(["lat": locationLat, "lon": locationLon], forKey: key)
    }
    
    func location(forKey key: String) -> CLLocation? {
        if let locationDictionary = self.object(forKey: key) as? [String: NSNumber] {
            let locationLat = locationDictionary["lat"]!.doubleValue
            let locationLon = locationDictionary["lon"]!.doubleValue
            return CLLocation(latitude: locationLat, longitude: locationLon)
        }
        return nil
    }
}
