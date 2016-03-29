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
        case Percent
        case Pressure
        case Speed
        case Temperature
        case Volume
    }
    
    func unitForValue(v: String, type t: Unit) -> String {
        let unit: String
        
        switch t {
        case .Percent:
            unit = "%"
        case .Pressure where self == .Imperial:
            unit = "in-Hg"
        case .Pressure:
            unit = "hpa"
        case .Speed where self == .Imperial:
            unit = "mph"
        case .Speed:
            unit = "km/h"
        case .Temperature where self == .Imperial:
            unit = "°F"
        case .Temperature:
            unit = "°C"
        case .Volume where self == .Imperial:
            unit = "inch"
        case .Volume:
            unit = "mm"
        }
        
        return "\(v)\(unit)"
    }
    
    func unitForValue(v: Double, type t: Unit) -> String {
        let value: Double
        
        switch t {
        case .Pressure where self == .Imperial:
            value = v.hpaToinhg()
        case .Speed where self == .Imperial:
            value = v.msTomph()
        case .Speed:
            value = v.msTokmh()
        case .Temperature where self == .Imperial:
            value = v.kelvinToFahrenheit()
        case .Temperature:
            value = v.kelvinToCelcius()
        case .Volume where self == .Imperial:
            value = v.mmToinch()
        default:
            value = v
        }
        
        let valueStr = value.roundToStringForUnits()
        
        return unitForValue(valueStr, type: t)
    }
    
}
