//
//  LocationService.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 24.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
	static let inst = LocationService()

	fileprivate let locationManager = CLLocationManager()

	fileprivate var _lat: String!
	fileprivate var _lon: String!

	fileprivate var _lastUpdate: Date!

	fileprivate var _counter = 0

	var apiLocation: String {
		guard let lat = _lat, let lon = _lon else {
			return ""
		}

		return "\(API_LAT)\(lat)\(API_LON)\(lon)"
	}

	func getLocation(_ forced: Bool) -> Bool {
		guard forced || _lastUpdate == nil || _lastUpdate.olderThan(inMinutes: 15) else {
			print("no location updated needed")
			locationIsAvailable()
			return false
		}

		return locationAuthStatus()
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = manager.location else {
			return locationIsNotAvailable()
		}

		guard _counter >= 3 else {
			// locationManager returns last location for the first three times.
			// this prevents getting the old location by taking the 4th location.
			return _counter += 1
		}

		_counter = 0

		locationManager.stopUpdatingLocation()

		let position = location.coordinate
		_lat = "\(position.latitude.roundTo(decimals: 3))"
		_lon = "\(position.longitude.roundTo(decimals: 3))"

		_lastUpdate = Date()

		locationIsAvailable()
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		locationManager.stopUpdatingLocation()
		locationIsNotAvailable()
	}

	fileprivate func locationAuthStatus() -> Bool {
		let status = CLLocationManager.authorizationStatus()

		switch status {
		case .authorizedWhenInUse, .authorizedAlways:
			return locationRequest()
		case .notDetermined:
			locationManager.requestWhenInUseAuthorization()
			return locationAuthStatus()
		default:
			return locationAuthError()
		}
	}

	fileprivate func locationRequest() -> Bool {
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
		locationManager.startUpdatingLocation()
		return true
	}

	fileprivate func locationAuthError() -> Bool {
		NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: Notification.locationAuthError.name), object: nil)
		return false
	}

	fileprivate func locationIsNotAvailable() {
		NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: Notification.locationUnavailable.name), object: nil)
	}

	fileprivate func locationIsAvailable() {
		NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: Notification.locationAvailable.name), object: nil)
	}
}
