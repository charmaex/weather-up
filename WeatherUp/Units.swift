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

	mutating func next() {
		switch self {
		case .metric: self = .imperial
		case .imperial: self = .metric
		}
	}

	func unit(for value: String, withUnit type: Unit) -> String {
		let unit: String

		switch type {
		case .percent: unit = "%"
		case .pressure where self == .imperial: unit = "in-Hg"
		case .pressure: unit = "hpa"
		case .speed where self == .imperial: unit = "mph"
		case .speed: unit = "km/h"
		case .temperature where self == .imperial: unit = "°F"
		case .temperature: unit = "°C"
		case .volume where self == .imperial: unit = "inch"
		case .volume: unit = "mm"
		}

		return "\(value)\(unit)"
	}

	func unit(for value: Double, withUnit type: Unit) -> String {
		var value = value

		switch type {
		case .pressure where self == .imperial: value = value.hpaToinhg()
		case .speed where self == .imperial: value = value.msTomph()
		case .speed: value = value.msTokmh()
		case .temperature where self == .imperial: value = value.kelvinToFahrenheit()
		case .temperature: value = value.kelvinToCelcius()
		case .volume where self == .imperial: value = value.mmToinch()
		default: break
		}

		let valueStr = value.roundToStringForUnits()

		return unit(for: valueStr, withUnit: type)
	}
}
