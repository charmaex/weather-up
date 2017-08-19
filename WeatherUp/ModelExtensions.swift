//
//  ModelExtensions.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 25.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

extension Double {

	func kelvinToCelcius() -> Double {
		return self - 273.15
	}

	func kelvinToFahrenheit() -> Double {
		return 1.8 * (self.kelvinToCelcius()) + 32
	}

	func msTokmh() -> Double {
		return self * 3.6
	}

	func msTomph() -> Double {
		return self * 2.2369362920544025
	}

	func mmToinch() -> Double {
		return self * 3 / 64
	}

	func hpaToinhg() -> Double {
		return self * 0.0295299830714
	}

	func roundToStringForUnits() -> String {
		return roundToString(decimals: 0)
	}

	func roundTo(decimals i: Int) -> Double {
		guard i >= 0 else {
			return self
		}
		let inc = pow(10, Double(i))

		return (self * inc).rounded() / inc
	}

	fileprivate func roundToString(decimals i: Int) -> String {
		let x = self.roundTo(decimals: i)
		return x.toString()
	}

	fileprivate func toString() -> String {
		return String(self).replacingOccurrences(of: ".0", with: "")
	}
}

extension String {

	func append(_ s: String, separator: String) -> String {
		guard self != "" && s != "" else {
			return self
		}
		return "\(self)\(separator)\(s)"
	}

	func toDate(withFormat format: String) -> Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format
		return dateFormatter.date(from: self)
	}

	func toDate() -> Date? {
		return self.toDate(withFormat: "yyyy-MM-dd HH:mm:ss")
	}

	func trunc(_ length: Int) -> String {
		if count > length {
			let truncIndex = index(startIndex, offsetBy: length)
			return String(self[startIndex ... truncIndex])
		} else {
			return self
		}
	}

	func removeRight(_ length: Int) -> String {
		let x = self.characters.count - length
		guard x > 0 else {
			return ""
		}
		return self.trunc(x)
	}
}

extension Date {

	func timeToString(withFormat format: String) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format
		return dateFormatter.string(from: self)
	}

	func timeToString() -> String {
		return self.timeToString(withFormat: "HH:mm")
	}

	func weekday() -> String {
		return self.timeToString(withFormat: "eeee")
	}

	func olderThan(inMinutes m: Double) -> Bool {
		return self.timeIntervalSinceNow < -m * 60
	}
}
