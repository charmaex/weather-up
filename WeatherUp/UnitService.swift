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
    
    private var _unit: Units = .Imperial
    
    var unit: Units {
        return _unit
    }
    
}
