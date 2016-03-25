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
    
    private var _degrees: String!
    private var _minDegr: String!
    private var _maxDegr: String!
    private var _img: String!
    private var _time: String!
    private var _location: String!
    
    init(degrees: String, minDegr: String, maxDegr: String, img: String, time: String, location: String) {
        _degrees = "\(degrees)\(DEF_UNIT_C)"
        _minDegr = "\(minDegr)\(DEF_UNIT_C)"
        _maxDegr = "\(maxDegr)\(DEF_UNIT_C)"
        _img = img
        _time = time
        _location = location
    }
    
    override init() {
        _degrees = DEF_DEGREES_C
        _minDegr = DEF_DEGREES_C
        _maxDegr = DEF_DEGREES_C
        _img = ""
        _time = ""
        _location = ""
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        
        self._degrees = aDecoder.decodeObjectForKey("degrees") as? String
        self._minDegr = aDecoder.decodeObjectForKey("minDegr") as? String
        self._maxDegr = aDecoder.decodeObjectForKey("maxDegr") as? String
        self._img = aDecoder.decodeObjectForKey("img") as? String
        self._time = aDecoder.decodeObjectForKey("time") as? String
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
