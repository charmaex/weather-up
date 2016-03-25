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

let API_APPID = "&appid=60531fc50ee5f20d8cd9e8bbe24d8976"

// Defaults
let DEF_UNIT_C = " °C"
let DEF_UNIT_F = " °F"
let DEF_DEGREES = -460.0

typealias Completion = () -> ()
