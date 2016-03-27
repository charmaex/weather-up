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
    private var _date: NSDate!
    private var _city: String!
    private var _country: String!
    private var _clouds: Double!
    private var _rain: Double!
    private var _wind: Double!
    private var _pressure: Double!
    private var _humidity: Double!
    
    func degrees(unit unit: TemperatureUnits) -> String {
        return _degrees.toDegrees(unit: unit)
    }
    
    func minDegr(unit unit: TemperatureUnits) -> String {
        return _minDegr.toDegrees(unit: unit)
    }
    
    func maxDegr(unit unit: TemperatureUnits) -> String {
        return _maxDegr.toDegrees(unit: unit)
    }
    
    var imageName: String {
        return "\(_img)\(IMG_SIZE)"
    }
    
    var mainDesc: String {
        return _mainDesc.capitalizedString
    }
    
    var desc: String {
        return _desc.capitalizedString
    }
    
    var location: String {
        let city = _city.capitalizedString
        let country = _country
        return "\(city), \(country)"
    }
    
    var time: String {
        let x = _date.timeToString()
        return "at: \(x)"
    }
    
    var clouds: String {
        return "\(_clouds.roundToString(decimals: 0))%"
    }
    
    var rain: String {
        return "\(_rain.roundToString(decimals: 0))mm"
    }
    
    var wind: String {
        let x = _wind.msTokmh()
        return "\(x.roundToString(decimals: 0))km/h"
    }
    
    var pressure: String {
        return "\(_pressure.roundToString(decimals: 0))mbar"
    }
    
    var humidity: String {
        return "\(_humidity.roundToString(decimals: 0))%"
    }
    
    init(degrees: Double, minDegr: Double, maxDegr: Double, img: String, mainDesc: String, desc: String, date: NSDate, city: String, country: String, clouds: Double, rain: Double, wind: Double, pressure: Double, humidity: Double) {
        _degrees = degrees
        _minDegr = minDegr
        _maxDegr = maxDegr
        _mainDesc = mainDesc
        _desc = desc
        _img = img
        _date = date
        _city = city
        _country = country
        _clouds = clouds
        _rain = rain
        _wind = wind
        _pressure = pressure
        _humidity = humidity
    }
    
    override init() {
        _degrees = DEF_DEGREES
        _minDegr = DEF_DEGREES
        _maxDegr = DEF_DEGREES
        _mainDesc = ""
        _desc = ""
        _img = DEF_IMG
        _date = DEF_DATE
        _city = ""
        _country = ""
        _clouds = DEF_DOUBLE
        _rain = DEF_DOUBLE
        _wind = DEF_DOUBLE
        _pressure = DEF_DOUBLE
        _humidity = DEF_DOUBLE
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        
        self._degrees = aDecoder.decodeObjectForKey("degrees") as? Double
        self._minDegr = aDecoder.decodeObjectForKey("minDegr") as? Double
        self._maxDegr = aDecoder.decodeObjectForKey("maxDegr") as? Double
        self._img = aDecoder.decodeObjectForKey("img") as? String
        self._date = aDecoder.decodeObjectForKey("date") as? NSDate
        self._city = aDecoder.decodeObjectForKey("city") as? String
        self._country = aDecoder.decodeObjectForKey("country") as?  String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self._degrees, forKey: "degrees")
        aCoder.encodeObject(self._minDegr, forKey: "minDegr")
        aCoder.encodeObject(self._maxDegr, forKey: "maxDegr")
        aCoder.encodeObject(self._img, forKey: "img")
        aCoder.encodeObject(self._date, forKey: "date")
        aCoder.encodeObject(self._city, forKey: "city")
        aCoder.encodeObject(self._country, forKey: "country")
    }
    
}
