//
//  WeatherObject.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 28.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

protocol WeatherObject {
	var imageSize: String { get }
	var degrees: Double { get }
	var imageName: String { get }
}

extension WeatherObject {

	var image: UIImage? {
		return UIImage(named: "\(imageName)\(imageSize)")
	}

	var textColor: UIColor {
		return Colors.textColor()
	}

	var bgColor: UIColor {
		switch degrees.kelvinToCelcius() {
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
		let s = s == nil ? "error" : s!
		return "\(s)\(imageSize)"
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
			return UnitService.inst.unit.unit(for: nilValue.rawValue, withUnit: type)
		}
		return UnitService.inst.unit.unit(for: d, withUnit: type)
	}
}
