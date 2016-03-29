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
        return self - 273.15
    }
    
    func kelvinToFahrenheit() -> Double {
        return 1.8 * (self.kelvinToCelcius()) + 32
    }
    
    func msTokmh() -> Double {
        return self * 3.6
    }
    
    func msTomph() -> Double {
        return self * 2.2369362920544025
    }
    
    func mmToinch() -> Double {
        return self * 3 / 64
    }
    
    func hpaToinhg() -> Double {
        return self * 0.0295299830714
    }
    
    func roundToStringForUnits() -> String {
        return roundToString(decimals: 0)
    }
    
    func roundTo(decimals i: Int) -> Double {
        guard i >= 0 else {
            return self
        }
        let inc = pow(10, Double(i))
        
        return round(self * inc) / inc
    }
    
    private func roundToString(decimals i: Int) -> String {
        let x = self.roundTo(decimals: i)
        return x.toString()
    }
    
    private func toString() -> String {
        return String(self).stringByReplacingOccurrencesOfString(".0", withString: "")
    }
    
}

extension String {
    
    func append(s: String, separator: String) -> String {
        guard self != "" && s != "" else {
            return self
        }
        return "\(self)\(separator)\(s)"
    }
    
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
    
    func olderThan(inMinutes m: Double) -> Bool {
        return self.timeIntervalSinceNow < -m * 60
    }
    
}
