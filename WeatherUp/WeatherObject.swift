//
//  WeatherObject.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 28.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

protocol WeatherObject {
    func valueSaveUnit(d: Double, type: UnitsType) -> String
}

extension WeatherObject {
    
    func valueSaveUnit(d: Double, type: UnitsType) -> String {
        if d == DEF_VALUE  {
            let defStr: String
            switch type {
            case .Temperature:
                defStr = DEF_EMPTY_TEMP
            default:
                defStr = DEF_EMPTY
            }
            return UnitService.inst.unit.unitForValue(defStr, type: type)
        }
        return UnitService.inst.unit.unitForValue(d, type: type)
    }
    
}
