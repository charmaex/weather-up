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
    private var _apiLocationNew = true
    
    private var _weather: Weather!
    private var _forecasts = [Forecast]()
    private var _lastWeather: NSDate!
    private var _lastForecast: NSDate!
    
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
        
        if let destination = destination {
            _apiLocationNew = _apiLocation == destination
            _apiLocation = destination
        } else {
            _apiLocationNew = _apiLocation == LocationService.inst.apiLocation
            _apiLocation = LocationService.inst.apiLocation
        }
        
        getNSUD()
        
        _downloadCount = 0
        _downloadCountTarget = 0
        
        //if _lastWeather + 59 min >= now || _apiLocationNew
        _downloadCountTarget += 1
        downloadWeather()
        
        //if _lastForecast + 5:59 min >= now || _apiLocationNew
        _downloadCountTarget += 1
        downloadForecast()
        
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
        }
        
        if let f = NSUserDefaults.standardUserDefaults().objectForKey("lastForecast") as? NSDate {
            _lastForecast = f
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
    
    private func downloadWeather() {
        downloadWeather {
            self._downloadCount += 1
            self.finishGetData()
        }
    }
    
    private func downloadForecast() {
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
                return self.downloadWeather()
            }

            var degrees = DEF_DEGREES
            var minDegr = DEF_DEGREES
            var maxDegr = DEF_DEGREES
            var mainDesc = ""
            var desc = ""
            var img = ""
            var city = ""
            var country = ""
            var clouds = ""
            var rain = ""
            var wind = ""
            var windDir = ""
            var humidity = ""
            
            if let res = result["main"] as? Dictionary<String, Double> {
                if let a = res["temp"] {
                    degrees = a
                }
                if let a = res["temp_min"] {
                    minDegr = a
                }
                if let a = res["temp_max"] {
                    maxDegr = a
                }
            }
            
            if let res = result["weather"] as? [Dictionary<String, AnyObject>] {
                if res.count >= 1 {
                    let re = res[0]
                    if let a = re["main"] as? String {
                        mainDesc = a
                    }
                    if let a = re["description"] as? String {
                        desc = a
                    }
                    if let a =  re["icon"] as? String {
                        img = a
                    }
                }
            }
            
            if let res = result["name"] as? String {
                city = res
            }

            if let res = result["sys"] as? Dictionary<String, AnyObject> {
                if let a = res["country"] as? String {
                    country = a
                }
            }
            
            let date = NSDate()
            
            self._lastWeather = date
            self._weather = Weather(degrees: degrees, minDegr: minDegr, maxDegr: maxDegr, img: img, mainDesc: mainDesc, desc: desc, date: date, city: city, country: country, clouds: clouds, rain: rain, wind: wind, windDir: windDir, humidity: humidity)

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
                return self.downloadForecast()
            }
            
            guard let list = result["list"] as? [Dictionary<String, AnyObject>] else {
                print("corrupt data")
                return completion()
            }

            var forecasts = [Forecast]()
            
            for item in list {
                
                guard let d = item["dt_txt"] as? String, let date = d.toDate() else {
                    continue
                }
                
                guard date.timeToString() == "15:00" else {
                    continue
                }
                
                var img = ""
                var degrees = DEF_DEGREES
                
                if let res = item["weather"] as? [Dictionary<String, AnyObject>] {
                    if res.count >= 1 {
                        if let a =  res[0]["icon"] as? String {
                            img = a
                        }
                    }
                }
                
                if let res = item["main"] as? Dictionary<String, Double> {
                    if let a = res["temp"] {
                        degrees = a
                    }
                }
                
                let forecast = Forecast(date: date, img: img, degrees: degrees)
                forecasts.append(forecast)
            }
            
            self._lastForecast = NSDate()
            self._forecasts = forecasts
            
            completion()
        }
    }
    
}
