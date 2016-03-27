//
//  LocationService.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 24.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation
import MapKit

class LocationService: NSObject, CLLocationManagerDelegate {
    static let inst = LocationService()
    
    let locationManager = CLLocationManager()
    
    private var _lat: String!
    private var _lon: String!
    
    var apiLocation: String {
        guard _lat != nil && _lon != nil else {
            return ""
        }
        return "\(API_LAT)\(_lat)\(API_LON)\(_lon)"
    }
    
    func getLocation() {
        locationAuthStatus()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else {
            locationIsNotAvailable()
            return
        }
        
        locationManager.stopUpdatingLocation()
        
        let position = location.coordinate
        _lat = "\(position.latitude.roundTo(decimals: 2))"
        _lon = "\(position.longitude.roundTo(decimals: 2))"
        
        locationIsAvailable()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        locationManager.stopUpdatingLocation()
        locationIsNotAvailable()
    }

    private func locationAuthStatus() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .AuthorizedWhenInUse, .AuthorizedAlways:
            locationRequest()
        case .NotDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        default:
            locationAuthError()
        }
        
    }
    
    private func locationRequest() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
    }
    
    private func locationAuthError() {
        NSNotificationCenter.defaultCenter().postNotificationName("locationAuthError", object: nil)
    }
    
    private func locationIsNotAvailable() {
        NSNotificationCenter.defaultCenter().postNotificationName("locationIsNotAvailable", object: nil)
    }
    
    private func locationIsAvailable() {
        NSNotificationCenter.defaultCenter().postNotificationName("locationIsAvailable", object: nil)
    }

}
