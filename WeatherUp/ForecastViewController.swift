//
//  ForecastViewController.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 22.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {

	@IBOutlet weak var dayLbl: StyledLabel!
	@IBOutlet weak var weatherImg: UIImageView!
	@IBOutlet weak var degreesLbl: StyledLabel!

	func initWithForecast(_ forecast: Forecast) {
		dayLbl.text = forecast.weekday
		weatherImg.image = forecast.image
		degreesLbl.text = forecast.degreesText

		dayLbl.forecast = forecast
		degreesLbl.forecast = forecast
	}
}
