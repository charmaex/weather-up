//
//  Units.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 28.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

enum UnitSystem: String {
    case Imperial
    case Metric
    
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
        case .pressure where self == .Imperial:
            unit = "in-Hg"
        case .pressure:
            unit = "hpa"
        case .speed where self == .Imperial:
            unit = "mph"
        case .speed:
            unit = "km/h"
        case .temperature where self == .Imperial:
            unit = "°F"
        case .temperature:
            unit = "°C"
        case .volume where self == .Imperial:
            unit = "inch"
        case .volume:
            unit = "mm"
        }
        
        return "\(v)\(unit)"
    }
    
    func unitForValue(_ v: Double, type t: Unit) -> String {
        let value: Double
        
        switch t {
        case .pressure where self == .Imperial:
            value = v.hpaToinhg()
        case .speed where self == .Imperial:
            value = v.msTomph()
        case .speed:
            value = v.msTokmh()
        case .temperature where self == .Imperial:
            value = v.kelvinToFahrenheit()
        case .temperature:
            value = v.kelvinToCelcius()
        case .volume where self == .Imperial:
            value = v.mmToinch()
        default:
            value = v
        }
        
        let valueStr = value.roundToStringForUnits()
        
        return unitForValue(valueStr, type: t)
    }
    
}
