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
    private var _lastWeather: String!
    private var _lastForecast: String!
    
    private var _downloadCount = 0
    private var _downloadCountTarget = 0
    
    var time: String {
        guard let x = _lastWeather else {
            return ""
        }
        return x
    }
    
    var weather: Weather {
        guard let x = _weather else {
            return Weather()
        }
        return x
    }
    
    var forecasts: [Forecast] {
        return _forecasts
    }
    
    func getData() {
        getNSUD()
        
        _downloadCount = 0
        _downloadCountTarget = 0
        
        //if _lastWeather + 59 min >= now
        _downloadCountTarget += 1
        downloadWeather {
            self._downloadCount += 1
            self.finishGetData()
        }
        
        //if _lastForecast + 5:59 min >= now
        _downloadCountTarget += 1
        downloadForecast {
            self._downloadCount += 1
            self.finishGetData()
        }
        
    }
    
    private func finishGetData() {
        guard _downloadCount == _downloadCountTarget && _downloadCount > 0 else {
            return
        }
        
        saveNSUD()
        postNotification()
    }
    
    private func postNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName("gotData", object: nil)
    }
    
    private func getNSUD() {
        if let weatherData = NSUserDefaults.standardUserDefaults().objectForKey("weather") as? NSData {
            if let weatherClass = NSKeyedUnarchiver.unarchiveObjectWithData(weatherData) as? Weather {
                _weather = weatherClass
            }
        }
        if let forecastData = NSUserDefaults.standardUserDefaults().objectForKey("forecasts") as? NSData {
            if let forecastArray = NSKeyedUnarchiver.unarchiveObjectWithData(forecastData) as? [Forecast] {
                _forecasts = forecastArray
            }
        }
        
        if let w = NSUserDefaults.standardUserDefaults().valueForKey("lastWeather") as? String {
            _lastWeather = w
        }
        if let f = NSUserDefaults.standardUserDefaults().valueForKey("lastForecast") as? String {
            _lastForecast = f
        }
    }
    
    private func saveNSUD() {
        let weatherData = NSKeyedArchiver.archivedDataWithRootObject(_weather)
        NSUserDefaults.standardUserDefaults().setObject(weatherData, forKey: "weather")
        
        let forecastsData = NSKeyedArchiver.archivedDataWithRootObject(_forecasts)
        NSUserDefaults.standardUserDefaults().setObject(forecastsData, forKey: "forecasts")
        
        NSUserDefaults.standardUserDefaults().setValue(_lastWeather, forKey: "lastWeather")
        NSUserDefaults.standardUserDefaults().setValue(_lastForecast, forKey: "lastForecast")
        
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    private func downloadWeather(completion: Completion) {
        
    }
    
    private func downloadForecast(completion: Completion) {
        
    }
}
