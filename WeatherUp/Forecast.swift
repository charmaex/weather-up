//
//  Forecast.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 23.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

class Forecast: NSObject, NSCoding {
    
    private let IMG_SIZE = "55"
    
    private var _date: NSDate!
    private var _img: String!
    private var _degrees: Double!
    
    var weekday: String {
        let x: String = _date.weekday()
        return x.capitalizedString
    }
    
    var imageName: String {
        return "\(_img)\(IMG_SIZE)"
    }
    
    func degrees(unit unit: TemperatureUnits) -> String {
        return degreeConvert(_degrees, unit: unit)
    }
    
    private func degreeConvert(value: Double, unit: TemperatureUnits) -> String {
        let degr: Double
        
        switch unit {
        case .Celcius:
            degr = value.kelvinToCelcius()
        case .Fahrenheit:
            degr = value.kelvinToFahrenheit()
        }
        
        return "\(degr)\(unit.rawValue)"
    }
    
    init(date: NSDate, img: String, degrees: Double) {
        _date = date
        _img = img
        _degrees = degrees
    }
    
    override init() {
        _img = ""
        _degrees = DEF_DEGREES
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
        
        self._date = aDecoder.decodeObjectForKey("date") as? NSDate
        self._img = aDecoder.decodeObjectForKey("img") as? String
        self._degrees = aDecoder.decodeObjectForKey("degrees") as? Double
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self._date, forKey: "date")
        aCoder.encodeObject(self._img, forKey: "img")
        aCoder.encodeObject(self._degrees, forKey: "degrees")
    }
    
}
