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
    
    fileprivate var _degrees: Double!
    fileprivate var _minDegr: Double!
    fileprivate var _maxDegr: Double!
    fileprivate var _img: String!
    fileprivate var _mainDesc: String!
    fileprivate var _desc: String!
    fileprivate var _date: Date!
    fileprivate var _city: String!
    fileprivate var _country: String!
    fileprivate var _clouds: Double!
    fileprivate var _rain: Double!
    fileprivate var _snow: Double!
    fileprivate var _wind: Double!
    fileprivate var _pressure: Double!
    fileprivate var _humidity: Double!
    
    var imageName: String {
        return saveImageName(_img)
    }
    
    var degreesDbl: Double {
        return _degrees
    }
    
    var degrees: String {
        return saveUnit(_degrees, type: .temperature, nilValue: .Dash)
    }
    
    var minDegr: String {
        return saveUnit(_minDegr, type: .temperature, nilValue: .Dash)
    }
    
    var maxDegr: String {
        return saveUnit(_maxDegr, type: .temperature, nilValue: .Dash)
    }
    
    var mainDesc: String {
        return saveCaseCapString(_mainDesc)
    }
    
    var desc: String {
        return saveCaseCapString(_desc)
    }
    
    var location: String {
        let city = saveCaseCapString(_city)
        let country = saveCaseUppString(_country)
        
        return city.append(country, separator: ", ")
    }
    
    var time: String {
        let x = saveTime(_date)
        return x == "" ? "" : "at: \(x)"
    }
    
    var clouds: String {
        return saveUnit(_clouds, type: .percent, nilValue: .Zero)
    }
    
    var rain: String {
        let x = saveSum(d1: _rain, d2: _snow)
        return saveUnit(x, type: .volume, nilValue: .Zero)
    }
    
    var wind: String {
        return saveUnit(_wind, type: .speed, nilValue: .Zero)
    }
    
    var pressure: String {
        return saveUnit(_pressure, type: .pressure, nilValue: .Dash)
    }
    
    var humidity: String {
        return saveUnit(_humidity, type: .percent, nilValue: .Zero)
    }
    
    init(degrees: Double, minDegr: Double, maxDegr: Double, img: String, mainDesc: String, desc: String, date: Date, city: String, country: String, clouds: Double, rain: Double, snow: Double, wind: Double, pressure: Double, humidity: Double) {
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
        _date = DEF_DATE as Date!
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
        
        _degrees = aDecoder.decodeObject(forKey: "degrees") as? Double
        _minDegr = aDecoder.decodeObject(forKey: "minDegr") as? Double
        _maxDegr = aDecoder.decodeObject(forKey: "maxDegr") as? Double
        _mainDesc = aDecoder.decodeObject(forKey: "mainDesc") as? String
        _desc = aDecoder.decodeObject(forKey: "desc") as? String
        _img = aDecoder.decodeObject(forKey: "img") as? String
        _date = aDecoder.decodeObject(forKey: "date") as? Date
        _city = aDecoder.decodeObject(forKey: "city") as? String
        _country = aDecoder.decodeObject(forKey: "country") as?  String
        _clouds = aDecoder.decodeObject(forKey: "clouds") as? Double
        _rain = aDecoder.decodeObject(forKey: "rain") as? Double
        _snow = aDecoder.decodeObject(forKey: "snow") as? Double
        _wind = aDecoder.decodeObject(forKey: "wind") as? Double
        _pressure = aDecoder.decodeObject(forKey: "pressure") as? Double
        _humidity = aDecoder.decodeObject(forKey: "humidity") as? Double
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_degrees, forKey: "degrees")
        aCoder.encode(_minDegr, forKey: "minDegr")
        aCoder.encode(_maxDegr, forKey: "maxDegr")
        aCoder.encode(_mainDesc, forKey: "mainDesc")
        aCoder.encode(_desc, forKey: "desc")
        aCoder.encode(_img, forKey: "img")
        aCoder.encode(_date, forKey: "date")
        aCoder.encode(_city, forKey: "city")
        aCoder.encode(_country, forKey: "country")
        aCoder.encode(_clouds, forKey: "clouds")
        aCoder.encode(_rain, forKey: "rain")
        aCoder.encode(_snow, forKey: "snow")
        aCoder.encode(_wind, forKey: "wind")
        aCoder.encode(_pressure, forKey: "pressure")
        aCoder.encode(_humidity, forKey: "humidity")
    }
    
}
