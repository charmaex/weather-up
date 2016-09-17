//
//  WeatherObject.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 28.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

protocol WeatherObject {
	func saveCaseCapString(_ s: String!) -> String
	func saveCaseUppString(_ s: String!) -> String
	func saveImageName(_ s: String!) -> String
	func saveSum(d1: Double!, d2: Double!) -> Double
	func saveTime(_ d: Date!) -> String
	func saveUnit(_ d: Double!, type: UnitSystem.Unit, nilValue: DefaultNilValue) -> String
	func saveWDay(_ d: Date!) -> String

	var IMG_SIZE: String { get }
	var degreesDbl: Double { get }
	var imageName: String { get }

	var textColor: UIColor { get }
	var bgColor: UIColor { get }
}

extension WeatherObject {

	var textColor: UIColor {
		return Colors.textColor()
	}

	var bgColor: UIColor {
		switch degreesDbl.kelvinToCelcius() {
		case let x where x > 30:
			return Colors.backgroundHot()
		case let x where x > 20:
			return Colors.backgroundWarm()
		case let x where x > 10:
			return Colors.backgroundModerate()
		case let x where x > 0:
			return Colors.backgroundCold()
		default:
			return Colors.backgroundFreeze()
		}
	}

	func saveTime(_ d: Date!) -> String {
		guard d != nil else {
			return ""
		}
		return d.timeToString()
	}

	func saveWDay(_ d: Date!) -> String {
		guard d != nil else {
			return ""
		}
		let x = d.weekday()
		if x == Date().weekday() {
			return "Today"
		}
		return x.capitalized
	}

	func saveSum(d1: Double!, d2: Double!) -> Double {
		let d1: Double = d1 == nil || d1 == DEF_VALUE ? 0 : d1
		let d2: Double = d2 == nil || d2 == DEF_VALUE ? 0 : d2
		return d1 + d2
	}

	func saveImageName(_ s: String!) -> String {
		let s = s == nil ? "error" : s
		return "\(s)\(IMG_SIZE)"
	}

	func saveCaseCapString(_ s: String!) -> String {
		guard s != nil else {
			return ""
		}
		return s.capitalized
	}

	func saveCaseUppString(_ s: String!) -> String {
		let s = saveCaseCapString(s)
		return s.uppercased()
	}

	func saveUnit(_ d: Double!, type: UnitSystem.Unit, nilValue: DefaultNilValue) -> String {
		guard d != nil && d != DEF_VALUE else {
			return UnitService.inst.unit.unitForValue(nilValue.rawValue, type: type)
		}
		return UnitService.inst.unit.unitForValue(d, type: type)
	}
}
