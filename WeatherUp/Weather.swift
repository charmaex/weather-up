//
//  Weather.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 23.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

class Weather: NSObject, NSCoding {
    
    private let IMG_SIZE = "160"
    
    private var _degrees: Double!
    private var _minDegr: Double!
    private var _maxDegr: Double!
    private var _img: String!
    private var _mainDesc: String!
    private var _desc: String!
    private var _date: NSDate?
    private var _location: String!
    
    func degrees(unit unit: TemperatureUnits) -> String {
        return degreeConvert(_degrees, unit: unit)
    }
    
    func minDegr(unit unit: TemperatureUnits) -> String {
        return degreeConvert(_minDegr, unit: unit)
    }
    
    func maxDegr(unit unit: TemperatureUnits) -> String {
        return degreeConvert(_maxDegr, unit: unit)
    }
    
    var imageName: String {
        return "\(_img)\(IMG_SIZE)"
    }
    
    var desc: String {
        return _desc
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
    
    init(degrees: Double, minDegr: Double, maxDegr: Double, img: String, mainDesc: String, desc: String, date: NSDate, city: String, country: String) {
        _degrees = degrees
        _minDegr = minDegr
        _maxDegr = maxDegr
        _mainDesc = mainDesc
        _desc = desc
        _img = img
        _date = date
        _location = "\(city), \(country)"
    }
    
    override init() {
        _degrees = DEF_DEGREES
        _minDegr = DEF_DEGREES
        _maxDegr = DEF_DEGREES
        _mainDesc = ""
        _desc = ""
        _img = ""
        _location = ""
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        
        self._degrees = aDecoder.decodeObjectForKey("degrees") as? Double
        self._minDegr = aDecoder.decodeObjectForKey("minDegr") as? Double
        self._maxDegr = aDecoder.decodeObjectForKey("maxDegr") as? Double
        self._img = aDecoder.decodeObjectForKey("img") as? String
        self._date = aDecoder.decodeObjectForKey("date") as? NSDate
        self._location = aDecoder.decodeObjectForKey("location") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self._degrees, forKey: "degrees")
        aCoder.encodeObject(self._minDegr, forKey: "minDegr")
        aCoder.encodeObject(self._maxDegr, forKey: "maxDegr")
        aCoder.encodeObject(self._img, forKey: "img")
        aCoder.encodeObject(self._date, forKey: "date")
        aCoder.encodeObject(self._location, forKey: "location")
    }
    
}
