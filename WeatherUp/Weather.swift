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
    private var _description: String!
    private var _time: NSDate?
    private var _location: String!
    
    init(degrees: Double, minDegr: Double, maxDegr: Double, img: String, desc: String, time: NSDate, city: String, country: String) {
        _degrees = degrees
        _minDegr = minDegr
        _maxDegr = maxDegr
        _description = desc
        _img = img
        _time = time
        _location = "\(city), \(country)"
    }
    
    override init() {
        _degrees = DEF_DEGREES
        _minDegr = DEF_DEGREES
        _maxDegr = DEF_DEGREES
        _description = ""
        _img = ""
        _location = ""
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        
        self._degrees = aDecoder.decodeObjectForKey("degrees") as? Double
        self._minDegr = aDecoder.decodeObjectForKey("minDegr") as? Double
        self._maxDegr = aDecoder.decodeObjectForKey("maxDegr") as? Double
        self._img = aDecoder.decodeObjectForKey("img") as? String
        self._time = aDecoder.decodeObjectForKey("time") as? NSDate
        self._location = aDecoder.decodeObjectForKey("location") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self._degrees, forKey: "degrees")
        aCoder.encodeObject(self._minDegr, forKey: "minDegr")
        aCoder.encodeObject(self._maxDegr, forKey: "maxDegr")
        aCoder.encodeObject(self._img, forKey: "img")
        aCoder.encodeObject(self._time, forKey: "time")
        aCoder.encodeObject(self._location, forKey: "location")
    }
    
}
