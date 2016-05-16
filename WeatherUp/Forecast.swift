//
//  Forecast.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 23.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

class Forecast: NSObject, NSCoding, WeatherObject {
    
    let IMG_SIZE = "055"
    
    private var _date: NSDate!
    private var _img: String!
    private var _degrees: Double!
    
    var weekday: String {
        return saveWDay(_date)
    }
    
    var imageName: String {
        return saveImageName(_img)
    }
    
    var degreesDbl: Double {
        return _degrees
    }
    
    var degrees: String {
        return saveUnit(_degrees, type: .Temperature, nilValue: .Dash)
    }
    
    init(date: NSDate, img: String, degrees: Double) {
        _date = date
        _img = img
        _degrees = degrees
    }
    
    override init() {
        _date = DEF_DATE
        _img = DEF_IMG
        _degrees = DEF_VALUE
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
