//
//  Units.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 28.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

enum UnitsType {
    case Percent
    case Pressure
    case Speed
    case Temperature
    case Volume
}

enum Units: String {
    case Imperial
    case Metric
    
    func unitForValue(v: String, type t: UnitsType) -> String {
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
    
    func unitForValue(v: Double, type t: UnitsType) -> String {
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
        
        let valueStr = value.roundToString(decimals: 0)
        
        return unitForValue(valueStr, type: t)
    }
    
}
