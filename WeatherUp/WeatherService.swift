//
//  WeatherService.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 23.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

class WeatherService {
    static let inst = WeatherService()
    
    private var _weather: Weather!
    private var _forecasts = [Forecast]()
    
    var weather: Weather {
        guard let x = _weather else {
            return Weather()
        }
        return x
    }
    var forecasts: [Forecast] {
        return _forecasts
    }
    
}