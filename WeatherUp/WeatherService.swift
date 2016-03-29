//
//  WeatherService.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 23.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation
import Alamofire

class WeatherService {
    static let inst = WeatherService()
    
    private var _apiLocation = ""
    private var _locationNew = true
    
    private var _weather: Weather!
    private var _forecasts = [Forecast]()
    private var _lastWeather: NSDate!
    private var _lastForecast: NSDate!
    private var _lastWeatherIncomplete = true
    private var _lastForecastIncomplete = true
    
    private var _downloadCount = 0
    private var _downloadCountTarget = 0
    
    var weather: Weather {
        guard let x = _weather else {
            return Weather()
        }
        return x
    }
    
    var forecasts: [Forecast] {
        return _forecasts
    }
    
    func getData(destination: String?) {
        
        if let dest = destination {
            _locationNew = _apiLocation != dest
            _apiLocation = dest
        } else {
            _locationNew = _apiLocation != LocationService.inst.apiLocation
            _apiLocation = LocationService.inst.apiLocation
        }
        
        getNSUD()
        
        _downloadCount = 0
        _downloadCountTarget = 0
        
        if _lastWeather.olderThan(inMinutes: 30) || _locationNew || _lastWeatherIncomplete {
            print("weather update")
            downloadWeather(initial: true)
        }
        if _lastForecast.olderThan(inMinutes: 120) || _locationNew || _lastForecastIncomplete {
            print("forecast update")
            downloadForecast(initial: true)
        }
        
        if _downloadCountTarget == 0 {
            print("no weather update needed")
            postNotification()
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
        NSNotificationCenter.defaultCenter().postNotificationName("gotWeatherData", object: nil)
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
        
        if let w = NSUserDefaults.standardUserDefaults().objectForKey("lastWeather") as? NSDate {
            _lastWeather = w
        } else if _lastWeather == nil {
            _lastWeather = NSDate(timeIntervalSince1970: 0)
        }
        
        if let f = NSUserDefaults.standardUserDefaults().objectForKey("lastForecast") as? NSDate {
            _lastForecast = f
        } else if _lastForecast == nil {
            _lastForecast = NSDate(timeIntervalSince1970: 0)
        }
    }
    
    private func saveNSUD() {
        let weatherData = NSKeyedArchiver.archivedDataWithRootObject(_weather)
        NSUserDefaults.standardUserDefaults().setObject(weatherData, forKey: "weather")
        
        let forecastsData = NSKeyedArchiver.archivedDataWithRootObject(_forecasts)
        NSUserDefaults.standardUserDefaults().setObject(forecastsData, forKey: "forecasts")
        
        NSUserDefaults.standardUserDefaults().setObject(_lastWeather, forKey: "lastWeather")
        NSUserDefaults.standardUserDefaults().setObject(_lastForecast, forKey: "lastForecast")
        
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    private func downloadWeather(initial b: Bool) {
        if b {
            _downloadCountTarget += 1
        }
        
        downloadWeather {
            self._downloadCount += 1
            self.finishGetData()
        }
    }
    
    private func downloadForecast(initial b: Bool) {
        if b {
            _downloadCountTarget += 1
        }
        
        downloadForecast {
            self._downloadCount += 1
            self.finishGetData()
        }
    }
    
    private func downloadWeather(completion: Completion) {
        guard let url = NSURL(string: "\(API_BASE)\(API_WEATHER)\(_apiLocation)\(API_APPID)") else {
            print("wrong url")
            return
        }
        
        Alamofire.request(.GET, url).responseJSON { (response: Response<AnyObject, NSError>) -> Void in
            guard let result = response.result.value as? [String: AnyObject] else {
                return self.downloadWeather(initial: false)
            }
            
            var counter = 12

            var degrees = DEF_VALUE
            var minDegr = DEF_VALUE
            var maxDegr = DEF_VALUE
            var mainDesc = ""
            var desc = ""
            var img = ""
            var city = ""
            var country = ""
            var clouds = DEF_VALUE
            var rain = DEF_VALUE
            var snow = DEF_VALUE
            var wind = DEF_VALUE
            var pressure = DEF_VALUE
            var humidity = DEF_VALUE
            
            if let res = result["main"] as? Dictionary<String, Double> {
                if let a = res["temp"] {
                    degrees = a
                    counter -= 1
                }
                if let a = res["temp_min"] {
                    minDegr = a
                    counter -= 1
                }
                if let a = res["temp_max"] {
                    maxDegr = a
                    counter -= 1
                }
                if let a = res["humidity"] {
                    humidity = a
                    counter -= 1
                }
                if let a = res["pressure"] {
                    pressure = a
                    counter -= 1
                }
            }
            
            if let res = result["weather"] as? [Dictionary<String, AnyObject>] {
                if res.count >= 1 {
                    let re = res[0]
                    if let a = re["main"] as? String {
                        mainDesc = a
                        counter -= 1
                    }
                    if let a = re["description"] as? String {
                        desc = a
                        counter -= 1
                    }
                    if let a =  re["icon"] as? String {
                        img = a
                        counter -= 1
                    }
                }
            }
            
            if let a = result["name"] as? String {
                city = a
                counter -= 1
            }

            if let res = result["sys"] as? Dictionary<String, AnyObject> {
                if let a = res["country"] as? String {
                    country = a
                    counter -= 1
                }
            }
            
            if let res = result["clouds"] as? Dictionary<String, Double> {
                if let a = res["all"] {
                    clouds = a
                    counter -= 1
                }
            }
            
            if let res = result["rain"] as? Dictionary<String, Double> {
                if let a = res["3h"] {
                    rain = a
                }
            }
            
            if let res = result["snow"] as? Dictionary<String, Double> {
                if let a = res["3h"] {
                    snow = a
                }
            }
            
            if let res = result["wind"] as? Dictionary<String, Double> {
                if let a = res["speed"] {
                    wind = a
                    counter -= 1
                }
            }
            
            let date = NSDate()
            
            let weather = Weather(degrees: degrees, minDegr: minDegr, maxDegr: maxDegr, img: img, mainDesc: mainDesc, desc: desc, date: date, city: city, country: country, clouds: clouds, rain: rain, snow: snow, wind: wind, pressure: pressure, humidity: humidity)
            
            self._lastWeatherIncomplete = counter > 0
            
            self._lastWeather = date
            self._weather = weather

            completion()
        }
    }
    
    private func downloadForecast(completion: Completion) {
        guard let url = NSURL(string: "\(API_BASE)\(API_FORECAST)\(_apiLocation)\(API_APPID)") else {
            print("wrong url")
            return completion()
        }
        
        Alamofire.request(.GET, url).responseJSON { response -> Void in
            guard let result = response.result.value as? [String: AnyObject] else {
                return self.downloadForecast(initial: false)
            }
            
            guard let list = result["list"] as? [Dictionary<String, AnyObject>] else {
                print("corrupt data")
                return completion()
            }

            var forecasts = [Forecast]()
            
            var counter = 2 * 5
            
            for item in list {
                
                guard let d = item["dt_txt"] as? String, let date = d.toDate() else {
                    continue
                }
                
                guard date.timeToString() == "15:00" else {
                    continue
                }
                
                var img = ""
                var degrees = DEF_VALUE
                
                if let res = item["weather"] as? [Dictionary<String, AnyObject>] {
                    if res.count >= 1 {
                        if let a =  res[0]["icon"] as? String {
                            img = a
                            counter -= 1
                        }
                    }
                }
                
                if let res = item["main"] as? Dictionary<String, Double> {
                    if let a = res["temp"] {
                        degrees = a
                        counter -= 1
                    }
                }
                
                let forecast = Forecast(date: date, img: img, degrees: degrees)
                forecasts.append(forecast)
            }
            
            self._lastForecastIncomplete = counter > 0
            
            self._lastForecast = NSDate()
            self._forecasts = forecasts
            
            completion()
        }
    }
    
}
