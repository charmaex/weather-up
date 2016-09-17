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

	fileprivate var _unit: UnitSystem = .Metric

	var unit: UnitSystem {
		return _unit
	}

	init() {
		if let data = UserDefaults.standard.value(forKey: "unit") as? String, let unit = UnitSystem(rawValue: data) {
			_unit = unit
		}
	}

	func switchUnit() {
		switch _unit {
		case .Metric:
			_unit = .Imperial
		case .Imperial:
			_unit = .Metric
		}
		saveUnit()
	}

	fileprivate func saveUnit() {
		UserDefaults.standard.setValue(_unit.rawValue, forKey: "unit")
		UserDefaults.standard.synchronize()
	}
}
