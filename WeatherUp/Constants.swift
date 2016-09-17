//
//  Constants.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 23.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

// API
let API_BASE = "http://api.openweathermap.org/data/2.5/"
let API_WEATHER = "weather?"
let API_FORECAST = "forecast?"

let API_LAT = "lat="
let API_LON = "&lon="

//let API_APPID = "&appid=#openweathermap.org_appID#"

// Defaults
let DEF_DATE = Date(timeIntervalSince1970: 0)
let DEF_IMG = ""
let DEF_VALUE = -1.0

enum DefaultNilValue: String {
    case Zero = "0"
    case Dash = "--"
}

// Errors
let ERR_NOAUTH = "Location services disabled."
let ERR_LOCATE = "Could not locate."

// Messages
let MES_LOCATE = "Locating..."
let MES_WEATHER = "Downloading weather info..."

typealias Completion = () -> ()

enum Notification: String {
    
    case LocationAvailable
    case LocationUnavailable
    case LocationAuthError
    
    case WeatherUpdated
    case WeatherOldData
    
    case UserSwitchUnits
    case UserUpdateLocation
    
    case UpdateStyles
    
    var name: String {
        return self.rawValue
    }
    
    enum Listener {
        case mainVC
        
        var object: Int {
            return self.hashValue
        }
    }
}
