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
    
    init(degrees: String, minDegr: String, maxDegr: String, img: String) {
        _degrees = degrees
        _minDegr = minDegr
        _maxDegr = maxDegr
        _img = img
    }
    
    override init() {
        _degrees = ""
        _minDegr = ""
        _maxDegr = ""
        _img = ""
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        
        self._degrees = aDecoder.decodeObjectForKey("degrees") as? String
        self._minDegr = aDecoder.decodeObjectForKey("minDegr") as? String
        self._maxDegr = aDecoder.decodeObjectForKey("maxDegr") as? String
        self._img = aDecoder.decodeObjectForKey("img") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self._degrees, forKey: "degrees")
        aCoder.encodeObject(self._minDegr, forKey: "minDegr")
        aCoder.encodeObject(self._maxDegr, forKey: "maxDegr")
        aCoder.encodeObject(self._img, forKey: "img")
    }
    
}