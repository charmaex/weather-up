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
    
    private var _unit: UnitSystem = .Metric
    
    var unit: UnitSystem {
        return _unit
    }
    
    init() {
        if let data = NSUserDefaults.standardUserDefaults().valueForKey("unit") as? String, let unit = UnitSystem(rawValue: data) {
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
    
    private func saveUnit() {
        NSUserDefaults.standardUserDefaults().setValue(_unit.rawValue, forKey: "unit")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
