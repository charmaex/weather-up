//
//  AlertViewController.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 27.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class AlertViewController: UIAlertController {

	override var preferredStyle: UIAlertControllerStyle {
		return .alert
	}

	func configureLocationAlert() {

		title = "Location Services Disabled"
		message = "Please enable location services for this app in Settings."

		let settingsAction = UIAlertAction(title: "Settings", style: .cancel) { (UIAlertAction) in

			let url = URL(string: "prefs:root=LOCATION_SERVICES")!
			UIApplication.shared.openURL(url)
		}

		let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

		addAction(settingsAction)
		addAction(okAction)

		preferredAction = settingsAction
	}
}
