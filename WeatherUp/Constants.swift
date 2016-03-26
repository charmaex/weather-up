//
//  Constants.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 23.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

// API
let API_BASE = "http://api.openweathermap.org/data/2.5/"
let API_WEATHER = "weather?"
let API_FORECAST = "forecast?"

let API_LAT = "lat="
let API_LON = "&lon="

//let API_APPID = "&appid=#openweathermap.org_appID#"

// Defaults
let DEF_DEGREES = -1.0

enum TemperatureUnits: String {
    case Celcius = " °C"
    case Fahrenheit = " °F"
}

typealias Completion = () -> ()
