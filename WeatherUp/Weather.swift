//
//  Weather.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 23.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

class Weather: NSObject, NSCoding, WeatherObject {
    
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
    
    var degrees: String {
        return valueSaveUnit(_degrees, type: .Temperature)
    }
    
    var minDegr: String {
        return valueSaveUnit(_minDegr, type: .Temperature)
    }
    
    var maxDegr: String {
        return valueSaveUnit(_maxDegr, type: .Temperature)
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
        
        return city.append(_country, separator: ", ")
    }
    
    var time: String {
        let x = _date.timeToString()
        return "at: \(x)"
    }
    
    var clouds: String {
        return valueSaveUnit(_clouds, type: .Percent)
    }
    
    var rain: String {
        return valueSaveUnit(_rain, type: .Volume)
    }
    
    var wind: String {
        return valueSaveUnit(_wind, type: .Speed)
    }
    
    var pressure: String {
        return valueSaveUnit(_pressure, type: .Pressure)
    }
    
    var humidity: String {
        return valueSaveUnit(_humidity, type: .Percent)
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
        _degrees = DEF_VALUE
        _minDegr = DEF_VALUE
        _maxDegr = DEF_VALUE
        _mainDesc = ""
        _desc = ""
        _img = DEF_IMG
        _date = DEF_DATE
        _city = ""
        _country = ""
        _clouds = DEF_VALUE
        _rain = DEF_VALUE
        _wind = DEF_VALUE
        _pressure = DEF_VALUE
        _humidity = DEF_VALUE
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
