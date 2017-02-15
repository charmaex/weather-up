//
//  Forecast.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 23.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

struct Forecast: WeatherObject {
	let imageSize = "055"

	let date: Date
	let imageName: String
	let degrees: Double

	var weekday: String {
		return saveWDay(date)
	}

	var degreesText: String {
		return saveUnit(degrees, type: .temperature, nilValue: .dash)
	}

	var encoded: [String: AnyObject] {
		var data: [String: AnyObject] = [:]
		data["date"] = date as AnyObject
		data["img"] = imageName as AnyObject
		data["degrees"] = degrees as AnyObject
		return data
	}
}

extension Forecast {

	init() {
		date = DEF_DATE
		imageName = DEF_IMG
		degrees = DEF_VALUE
	}

	init(decodeFrom dictionary: [String: AnyObject]) {
		date = dictionary["date"] as! Date
		imageName = dictionary["img"] as! String
		degrees = dictionary["degrees"] as! Double
	}
}
