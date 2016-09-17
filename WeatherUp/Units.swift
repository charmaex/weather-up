//
//  Units.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 28.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

enum UnitSystem: String {
	case imperial
	case metric

	enum Unit {
		case percent
		case pressure
		case speed
		case temperature
		case volume
	}

	func unitForValue(_ v: String, type t: Unit) -> String {
		let unit: String

		switch t {
		case .percent:
			unit = "%"
		case .pressure where self == .imperial:
			unit = "in-Hg"
		case .pressure:
			unit = "hpa"
		case .speed where self == .imperial:
			unit = "mph"
		case .speed:
			unit = "km/h"
		case .temperature where self == .imperial:
			unit = "°F"
		case .temperature:
			unit = "°C"
		case .volume where self == .imperial:
			unit = "inch"
		case .volume:
			unit = "mm"
		}

		return "\(v)\(unit)"
	}

	func unitForValue(_ v: Double, type t: Unit) -> String {
		let value: Double

		switch t {
		case .pressure where self == .imperial:
			value = v.hpaToinhg()
		case .speed where self == .imperial:
			value = v.msTomph()
		case .speed:
			value = v.msTokmh()
		case .temperature where self == .imperial:
			value = v.kelvinToFahrenheit()
		case .temperature:
			value = v.kelvinToCelcius()
		case .volume where self == .imperial:
			value = v.mmToinch()
		default:
			value = v
		}

		let valueStr = value.roundToStringForUnits()

		return unitForValue(valueStr, type: t)
	}
}
