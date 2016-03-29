//
//  Weather.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 23.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

class Weather: NSObject, NSCoding, WeatherObject {
    
    let IMG_SIZE = "160"
    
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
    private var _snow: Double!
    private var _wind: Double!
    private var _pressure: Double!
    private var _humidity: Double!
    
    var degrees: String {
        return saveUnit(_degrees, type: .Temperature)
    }
    
    var minDegr: String {
        return saveUnit(_minDegr, type: .Temperature)
    }
    
    var maxDegr: String {
        return saveUnit(_maxDegr, type: .Temperature)
    }
    
    var imageName: String {
        return saveImageName(_img)
    }
    
    var mainDesc: String {
        return saveCaseCapString(_mainDesc)
    }
    
    var desc: String {
        return saveCaseCapString(_desc)
    }
    
    var location: String {
        let city = saveCaseCapString(_desc)
        let country = saveCaseUppString(_country)
        
        return city.append(country, separator: ", ")
    }
    
    var time: String {
        let x = saveTime(_date)
        return x == "" ? "" : "at: \(x)"
    }
    
    var clouds: String {
        return saveUnit(_clouds, type: .Percent)
    }
    
    var rain: String {
        let x = saveSum(d1: _rain, d2: _snow)
        return saveUnit(x, type: .Volume)
    }
    
    var wind: String {
        return saveUnit(_wind, type: .Speed)
    }
    
    var pressure: String {
        return saveUnit(_pressure, type: .Pressure)
    }
    
    var humidity: String {
        return saveUnit(_humidity, type: .Percent)
    }
    
    init(degrees: Double, minDegr: Double, maxDegr: Double, img: String, mainDesc: String, desc: String, date: NSDate, city: String, country: String, clouds: Double, rain: Double, snow: Double, wind: Double, pressure: Double, humidity: Double) {
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
        _snow = snow
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
        _snow = DEF_VALUE
        _wind = DEF_VALUE
        _pressure = DEF_VALUE
        _humidity = DEF_VALUE
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        
        _degrees = aDecoder.decodeObjectForKey("degrees") as? Double
        _minDegr = aDecoder.decodeObjectForKey("minDegr") as? Double
        _maxDegr = aDecoder.decodeObjectForKey("maxDegr") as? Double
        _mainDesc = aDecoder.decodeObjectForKey("mainDesc") as? String
        _desc = aDecoder.decodeObjectForKey("desc") as? String
        _img = aDecoder.decodeObjectForKey("img") as? String
        _date = aDecoder.decodeObjectForKey("date") as? NSDate
        _city = aDecoder.decodeObjectForKey("city") as? String
        _country = aDecoder.decodeObjectForKey("country") as?  String
        _clouds = aDecoder.decodeObjectForKey("clouds") as? Double
        _rain = aDecoder.decodeObjectForKey("rain") as? Double
        _snow = aDecoder.decodeObjectForKey("snow") as? Double
        _wind = aDecoder.decodeObjectForKey("wind") as? Double
        _pressure = aDecoder.decodeObjectForKey("pressure") as? Double
        _humidity = aDecoder.decodeObjectForKey("humidity") as? Double
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(_degrees, forKey: "degrees")
        aCoder.encodeObject(_minDegr, forKey: "minDegr")
        aCoder.encodeObject(_maxDegr, forKey: "maxDegr")
        aCoder.encodeObject(_mainDesc, forKey: "mainDesc")
        aCoder.encodeObject(_desc, forKey: "desc")
        aCoder.encodeObject(_img, forKey: "img")
        aCoder.encodeObject(_date, forKey: "date")
        aCoder.encodeObject(_city, forKey: "city")
        aCoder.encodeObject(_country, forKey: "country")
        aCoder.encodeObject(_clouds, forKey: "clouds")
        aCoder.encodeObject(_rain, forKey: "rain")
        aCoder.encodeObject(_snow, forKey: "snow")
        aCoder.encodeObject(_wind, forKey: "wind")
        aCoder.encodeObject(_pressure, forKey: "pressure")
        aCoder.encodeObject(_humidity, forKey: "humidity")
    }
    
}
