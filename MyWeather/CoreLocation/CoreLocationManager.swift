//
//  CoreLocationManager.swift
//  MyWeather
//
//  Created by DamMinhNghien on 19/9/24.
//

import Foundation
import CoreLocation
typealias LocationCompletion = (CLLocation) -> ()

final class CoreLocationManager: NSObject, CLLocationManagerDelegate{
    static let shared = CoreLocationManager()
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var currentCompletion: LocationCompletion?
    private override init(){
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    func askForLocationPermission(){
        locationManager.requestWhenInUseAuthorization()
    }
    func getCurrentLocation() -> CLLocation? {
        return currentLocation
    }
    func getCurrentLocation(completion: @escaping LocationCompletion) {
        print("call")
            currentCompletion = completion
        print("calling")
            locationManager.requestLocation()
        print("call ok")

    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("location manager authorization status changed")
        
        switch manager.authorizationStatus {
        case .authorizedAlways:
            print("user allow app to get location data when app is active or in background")
//            manager.requestLocation()
            
        case .authorizedWhenInUse:
            print("user allow app to get location data only when app is active")
            manager.requestLocation()
//            
        case .denied:
            print("user tap 'disallow' on the permission dialog, cant get location data")
            
        case .restricted:
            print("parental control setting disallow location data")
            
        case .notDetermined:
            print("the location permission dialog haven't shown before, user haven't tap allow/disallow")
            
        default:
            print("default")
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            currentLocation = location
            print("current location:\(location)")
            if let current = currentCompletion{
                print("current location is set")
                current(location)
            }

        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("location error:\(error)")
    }
    
}
