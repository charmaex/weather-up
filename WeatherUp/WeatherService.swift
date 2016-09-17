//
//  WeatherService.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 23.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Alamofire

class WeatherService {
	static let inst = WeatherService()

	fileprivate var _apiLocation = ""
	fileprivate var _locationNew = true

	fileprivate var _weather: Weather!
	fileprivate var _forecasts = [Forecast]()
	fileprivate var _lastWeather: Date!
	fileprivate var _lastForecast: Date!
	fileprivate var _lastWeatherIncomplete = true
	fileprivate var _lastForecastIncomplete = true

	fileprivate var _downloadCount = 0
	fileprivate var _downloadCountTarget = 0

	var weather: Weather {
		guard let x = _weather else {
			return Weather()
		}
		return x
	}

	var forecasts: [Forecast] {
		return _forecasts
	}

	func getData(_ destination: String?, forced: Bool) {

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

		if forced || _lastWeather.olderThan(inMinutes: 15) || _locationNew || _lastWeatherIncomplete {
			print("weather update")
			downloadWeather(initial: true)
		}
		if forced || _lastForecast.olderThan(inMinutes: 60) || _locationNew || _lastForecastIncomplete {
			print("forecast update")
			downloadForecast(initial: true)
		}

		if _downloadCountTarget == 0 {
			print("no weather update needed")
			postNotification(.WeatherOldData)
		}
	}

	fileprivate func finishGetData() {
		guard _downloadCount == _downloadCountTarget && _downloadCount > 0 else {
			return
		}

		saveNSUD()
		postNotification(.WeatherUpdated)
	}

	fileprivate func postNotification(_ type: Notification) {
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: type.name), object: nil)
	}

	fileprivate func getNSUD() {
		if let weatherData = UserDefaults.standard.object(forKey: "weather") as? Data {
			if let weatherClass = NSKeyedUnarchiver.unarchiveObject(with: weatherData) as? Weather {
				_weather = weatherClass
			}
		}
		if let forecastData = UserDefaults.standard.object(forKey: "forecasts") as? Data {
			if let forecastArray = NSKeyedUnarchiver.unarchiveObject(with: forecastData) as? [Forecast] {
				_forecasts = forecastArray
			}
		}

		if let w = UserDefaults.standard.object(forKey: "lastWeather") as? Date {
			_lastWeather = w
		} else if _lastWeather == nil {
			_lastWeather = Date(timeIntervalSince1970: 0)
		}

		if let f = UserDefaults.standard.object(forKey: "lastForecast") as? Date {
			_lastForecast = f
		} else if _lastForecast == nil {
			_lastForecast = Date(timeIntervalSince1970: 0)
		}
	}

	fileprivate func saveNSUD() {
		let weatherData = NSKeyedArchiver.archivedData(withRootObject: _weather)
		UserDefaults.standard.set(weatherData, forKey: "weather")

		let forecastsData = NSKeyedArchiver.archivedData(withRootObject: _forecasts)
		UserDefaults.standard.set(forecastsData, forKey: "forecasts")

		UserDefaults.standard.set(_lastWeather, forKey: "lastWeather")
		UserDefaults.standard.set(_lastForecast, forKey: "lastForecast")

		UserDefaults.standard.synchronize()
	}

	fileprivate func downloadWeather(initial b: Bool) {
		if b {
			_downloadCountTarget += 1
		}

		downloadWeather {
			self._downloadCount += 1
			self.finishGetData()
		}
	}

	fileprivate func downloadForecast(initial b: Bool) {
		if b {
			_downloadCountTarget += 1
		}

		downloadForecast {
			self._downloadCount += 1
			self.finishGetData()
		}
	}

	fileprivate func downloadWeather(_ completion: @escaping Completion) {
		let url = "\(API_BASE)\(API_WEATHER)\(_apiLocation)\(API_APPID)"

		Alamofire.request(url).responseJSON { response in
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
					if let a = re["icon"] as? String {
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

			let date = Date()

			let weather = Weather(degrees: degrees, minDegr: minDegr, maxDegr: maxDegr, img: img, mainDesc: mainDesc, desc: desc, date: date, city: city, country: country, clouds: clouds, rain: rain, snow: snow, wind: wind, pressure: pressure, humidity: humidity)

			self._lastWeatherIncomplete = counter > 0

			self._lastWeather = date
			self._weather = weather

			completion()
		}
	}

	fileprivate func downloadForecast(_ completion: @escaping Completion) {
		let url = "\(API_BASE)\(API_FORECAST)\(_apiLocation)\(API_APPID)"

		Alamofire.request(url).responseJSON { response in
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
						if let a = res[0]["icon"] as? String {
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

			self._lastForecast = Date()
			self._forecasts = forecasts

			completion()
		}
	}
}
