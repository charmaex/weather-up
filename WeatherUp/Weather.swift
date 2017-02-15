//
//  Weather.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 23.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

struct Weather: WeatherObject {
	let imageSize = "160"

	let degrees: Double
	let minimumDegrees: Double
	let maximumDegrees: Double
	let imageName: String
	let mainDescription: String
	let description: String
	let date: Date
	let city: String
	let country: String
	let clouds: Double
	let rain: Double
	let snow: Double
	let wind: Double
	let pressure: Double
	let humidity: Double

	var degreesText: String {
		return saveUnit(degrees, type: .temperature, nilValue: .dash)
	}

	var minimumDegreesText: String {
		return saveUnit(minimumDegrees, type: .temperature, nilValue: .dash)
	}

	var maximumDegreesText: String {
		return saveUnit(maximumDegrees, type: .temperature, nilValue: .dash)
	}

	var location: String {
		let city = saveCaseCapString(self.city)
		let country = saveCaseUppString(self.country)

		return city.append(country, separator: ", ")
	}

	var time: String {
		let x = saveTime(date)
		return x == "" ? "" : "at: \(x)"
	}

	var cloudsText: String {
		return saveUnit(clouds, type: .percent, nilValue: .zero)
	}

	var rainText: String {
		return saveUnit(rain + snow, type: .volume, nilValue: .zero)
	}

	var windText: String {
		return saveUnit(wind, type: .speed, nilValue: .zero)
	}

	var pressureText: String {
		return saveUnit(pressure, type: .pressure, nilValue: .dash)
	}

	var humidityText: String {
		return saveUnit(humidity, type: .percent, nilValue: .zero)
	}

	var encoded: [String: AnyObject] {
		var data: [String: AnyObject] = [:]
		data["degrees"] = degrees as AnyObject?
		data["minDegr"] = minimumDegrees as AnyObject?
		data["maxDegr"] = maximumDegrees as AnyObject?
		data["mainDesc"] = mainDescription as AnyObject?
		data["desc"] = description as AnyObject?
		data["img"] = imageName as AnyObject?
		data["date"] = date as AnyObject?
		data["city"] = city as AnyObject?
		data["country"] = country as AnyObject?
		data["clouds"] = clouds as AnyObject?
		data["rain"] = rain as AnyObject?
		data["snow"] = snow as AnyObject?
		data["wind"] = wind as AnyObject?
		data["pressure"] = pressure as AnyObject?
		data["humidity"] = humidity as AnyObject?
		return data
	}
}

extension Weather {

	init() {
		degrees = DEF_VALUE
		minimumDegrees = DEF_VALUE
		maximumDegrees = DEF_VALUE
		mainDescription = ""
		description = ""
		imageName = DEF_IMG
		date = DEF_DATE as Date!
		city = ""
		country = ""
		clouds = DEF_VALUE
		rain = DEF_VALUE
		snow = DEF_VALUE
		wind = DEF_VALUE
		pressure = DEF_VALUE
		humidity = DEF_VALUE
	}

	init(decodeFrom dictionary: [String: AnyObject]) {
		degrees = dictionary["degrees"] as! Double
		minimumDegrees = dictionary["minDegr"] as! Double
		maximumDegrees = dictionary["maxDegr"] as! Double
		mainDescription = dictionary["mainDesc"] as! String
		description = dictionary["desc"] as! String
		imageName = dictionary["img"] as! String
		date = dictionary["date"] as! Date
		city = dictionary["city"] as! String
		country = dictionary["country"] as! String
		clouds = dictionary["clouds"] as! Double
		rain = dictionary["rain"] as! Double
		snow = dictionary["snow"] as! Double
		wind = dictionary["wind"] as! Double
		pressure = dictionary["pressure"] as! Double
		humidity = dictionary["humidity"] as! Double
	}
}
