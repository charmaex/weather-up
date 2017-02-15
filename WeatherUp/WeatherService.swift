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

	private var _apiLocation = ""
	private var _locationNew = true

	private(set) lazy var weather: Weather = Weather()
	private(set) var forecasts = [Forecast]()
	private var _lastWeather: Date!
	private var _lastForecast: Date!
	private var _lastWeatherIncomplete = true
	private var _lastForecastIncomplete = true

	private var _downloadCount = 0
	private var _downloadCountTarget = 0

	func getData(_ destination: String?, forced: Bool) {

		if let dest = destination {
			_locationNew = _apiLocation != dest
			_apiLocation = dest
		} else {
			_locationNew = _apiLocation != LocationService.shared.apiLocation
			_apiLocation = LocationService.shared.apiLocation
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
			postNotification(.weatherOldData)
		}
	}

	private func finishGetData() {
		guard _downloadCount == _downloadCountTarget && _downloadCount > 0 else {
			return
		}

		saveNSUD()
		postNotification(.weatherUpdated)
	}

	private func postNotification(_ type: Notifications) {
		NotificationCenter.default.post(name: type.name, object: nil)
	}

	private func getNSUD() {
		if let weatherData = UserDefaults.standard.object(forKey: "weather") as? [String: AnyObject] {
			self.weather = Weather(decodeFrom: weatherData)
		}
		if let forecastData = UserDefaults.standard.object(forKey: "forecasts") as? [[String: AnyObject]] {
			forecasts = forecastData.map { Forecast(decodeFrom: $0) }
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

	private func saveNSUD() {
		let weatherData = weather.encoded
		UserDefaults.standard.set(weatherData, forKey: "weather")

		let forecastsData = forecasts.map { $0.encoded }
		UserDefaults.standard.set(forecastsData, forKey: "forecasts")

		UserDefaults.standard.set(_lastWeather, forKey: "lastWeather")
		UserDefaults.standard.set(_lastForecast, forKey: "lastForecast")

		UserDefaults.standard.synchronize()
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

	private func downloadWeather(_ completion: @escaping Completion) {
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

			let weather = Weather(degrees: degrees, minimumDegrees: minDegr, maximumDegrees: maxDegr, imageName: img, mainDescription: mainDesc, description: desc, date: date, city: city, country: country, clouds: clouds, rain: rain, snow: snow, wind: wind, pressure: pressure, humidity: humidity)

			self._lastWeatherIncomplete = counter > 0

			self._lastWeather = date
			self.weather = weather

			completion()
		}
	}

	private func downloadForecast(_ completion: @escaping Completion) {
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

				let forecast = Forecast(date: date, imageName: img, degrees: degrees)
				forecasts.append(forecast)
			}

			self._lastForecastIncomplete = counter > 0

			self._lastForecast = Date()
			self.forecasts = forecasts

			completion()
		}
	}
}
