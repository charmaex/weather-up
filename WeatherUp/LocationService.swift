//
//  LocationService.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 24.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation
import MapKit

class LocationService {
    static let inst = LocationService()
    
    let locationManager = CLLocationManager()
    
    func getLocation() {
        locationAuthStatus()
    }

    private func locationAuthStatus() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .AuthorizedWhenInUse, .AuthorizedAlways:
            setLocation()
        case .NotDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        default:
            break
        }
        
    }
    
    private func setLocation() {
        print("set location")
    }
    
}
