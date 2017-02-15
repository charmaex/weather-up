//
//  UnitService.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 28.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

class UnitService {
	static let inst = UnitService()

	private(set) var unit: UnitSystem = .metric

	init() {
		if let data = UserDefaults.standard.value(forKey: "unit") as? String, let unit = UnitSystem(rawValue: data) {
			self.unit = unit
		}
	}

	func switchUnit() {
		unit.next()
		UserDefaults.standard.setValue(unit.rawValue, forKey: "unit")
	}
}
