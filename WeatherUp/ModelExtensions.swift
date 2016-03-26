//
//  ModelExtensions.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 25.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation
import MapKit

extension CLLocationDegrees {
    
    func roundTo(decimals i: Int) -> Double {
        guard i >= 0 else {
            return self
        }
        let inc = pow(10, Double(i))
        
        return round(self * inc) / inc
    }
    
}

extension Double {
    
    func kelvinToCelcius() -> Double {
        return self - 273.15
    }
    
    func kelvinToFahrenheit() -> Double {
        return 1.8 * (self.kelvinToCelcius()) + 32
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
