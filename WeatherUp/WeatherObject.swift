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
        guard d != DEF_VALUE else {
            return UnitService.inst.unit.unitForValue(DEF_EMPTY, type: type)
        }
        return UnitService.inst.unit.unitForValue(d, type: type)
    }
    
}
