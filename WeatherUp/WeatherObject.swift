//
//  WeatherObject.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 28.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

protocol WeatherObject {
    func saveCaseCapString(s: String!) -> String
    func saveCaseUppString(s: String!) -> String
    func saveImageName(s: String!) -> String
    func saveSum(d1 d1: Double!, d2: Double!) -> Double
    func saveTime(d: NSDate!) -> String
    func saveUnit(d: Double!, type: UnitSystem.Unit, nilValue: DefaultNilValue) -> String
    func saveWDay(d: NSDate!) -> String
    
    var IMG_SIZE: String { get }
}

extension WeatherObject {
    
    func saveTime(d: NSDate!) -> String {
        guard d != nil else {
            return ""
        }
        return d.timeToString()
    }
    
    func saveWDay(d: NSDate!) -> String {
        guard d != nil else {
            return ""
        }
        let x = d.weekday()
        return x.capitalizedString
    }
    
    func saveSum(d1 d1: Double!, d2: Double!) -> Double {
        let d1: Double = d1 == nil || d1 == DEF_VALUE ? 0 : d1
        let d2: Double = d2 == nil || d2 == DEF_VALUE ? 0 : d2
        return d1 + d2
    }
    
    func saveImageName(s: String!) -> String {
        let s = s == nil ? "error" : s
        return "\(s)\(IMG_SIZE)"
    }
    
    func saveCaseCapString(s: String!) -> String {
        guard s != nil else {
            return ""
        }
        return s.capitalizedString
    }
    
    func saveCaseUppString(s: String!) -> String {
        let s = saveCaseCapString(s)
        return s.uppercaseString
    }
    
    func saveUnit(d: Double!, type: UnitSystem.Unit, nilValue: DefaultNilValue) -> String {
        guard d != nil && d != DEF_VALUE else {
            return UnitService.inst.unit.unitForValue(nilValue.rawValue, type: type)
        }
        return UnitService.inst.unit.unitForValue(d, type: type)
    }
    
}
