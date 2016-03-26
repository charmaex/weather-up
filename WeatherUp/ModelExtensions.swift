//
//  ModelExtensions.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 25.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation
import MapKit

extension Double {
    
    func kelvinToCelcius() -> Double {
        let x = self - 273.15
        return x.roundTo(decimals: 0)
    }
    
    func kelvinToFahrenheit() -> Double {
        let x = 1.8 * (self.kelvinToCelcius()) + 32
        return x.roundTo(decimals: 0)
    }
    
    func roundTo(decimals i: Int) -> Double {
        guard i >= 0 else {
            return self
        }
        let inc = pow(10, Double(i))
        
        return round(self * inc) / inc
    }
    
    func toDegrees(unit unit: TemperatureUnits) -> String {
        let degr: Double
        
        switch unit {
        case .Celsius:
            degr = self.kelvinToCelcius()
        case .Fahrenheit:
            degr = self.kelvinToFahrenheit()
        }
        
        let degrStr = String(degr).stringByReplacingOccurrencesOfString(".0", withString: "")
        
        return "\(degrStr)\(unit.rawValue)"
    }
    
}

extension String {
    
    func toDate(withFormat format: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.dateFromString(self)
    }
    
    func toDate() -> NSDate? {
        return self.toDate(withFormat: "yyyy-MM-dd HH:mm:ss")
    }
    
}

extension NSDate {
    
    func timeToString(withFormat format: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(self)
    }
    
    func timeToString() -> String {
        return self.timeToString(withFormat: "HH:mm")
    }
    
    func weekday() -> String {
        return self.timeToString(withFormat: "eeee")
    }
    
}
