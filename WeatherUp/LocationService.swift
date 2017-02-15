//
//  LocationService.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 24.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
	static let shared = LocationService()

	private static var locationManager = CLLocationManager()

	private var lat: String!
	private var lon: String!

	private var lastUpdate: Date!

	private var counter = 0

	var apiLocation: String {
		guard let lat = lat, let lon = lon else {
			return ""
		}

		return "\(API_LAT)\(lat)\(API_LON)\(lon)"
	}

	func getLocation(_ forced: Bool) -> Bool {
		guard forced || lastUpdate == nil || lastUpdate.olderThan(inMinutes: 15) else {
			print("no location updated needed")
			notification(for: .locationAvailable)
			return false
		}

		return locationAuthStatus()
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = manager.location else {
			return notification(for: .locationUnavailable)
		}

		guard counter >= 3 else {
			// locationManager returns last location for the first three times.
			// this prevents getting the old location by taking the 4th location.
			return counter += 1
		}

		counter = 0

		LocationService.locationManager.stopUpdatingLocation()

		let position = location.coordinate
		lat = "\(position.latitude.roundTo(decimals: 3))"
		lon = "\(position.longitude.roundTo(decimals: 3))"

		lastUpdate = Date()

		notification(for: .locationAvailable)
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		LocationService.locationManager.stopUpdatingLocation()
		notification(for: .locationUnavailable)
	}

	private func locationAuthStatus() -> Bool {
		let status = CLLocationManager.authorizationStatus()

		switch status {
		case .authorizedWhenInUse, .authorizedAlways:
			return locationRequest()
		case .notDetermined:
			LocationService.locationManager.requestWhenInUseAuthorization()
			return locationAuthStatus()
		default:
			notification(for: .locationAuthError)
			return false
		}
	}

	private func locationRequest() -> Bool {
		LocationService.locationManager.delegate = self
		LocationService.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
		LocationService.locationManager.startUpdatingLocation()
		return true
	}

	private func notification(for notification: Notifications) {
		NotificationCenter.default.post(name: notification.name, object: nil)
	}
}
