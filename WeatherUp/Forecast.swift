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
    
    private var _day: NSDate!
    private var _img: String!
    private var _degrees: Double!
    
    init(day: NSDate, img: String, degrees: Double) {
        _day = day
        _img = img
        _degrees = degrees
    }
    
    override init() {
        _img = ""
        _degrees = DEF_DEGREES
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
        
        self._day = aDecoder.decodeObjectForKey("day") as? NSDate
        self._img = aDecoder.decodeObjectForKey("img") as? String
        self._degrees = aDecoder.decodeObjectForKey("degrees") as? Double
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self._day, forKey: "day")
        aCoder.encodeObject(self._img, forKey: "img")
        aCoder.encodeObject(self._degrees, forKey: "degrees")
    }
    
}
