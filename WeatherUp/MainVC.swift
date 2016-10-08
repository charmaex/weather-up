//
//  MainVC.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 01.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

	@IBOutlet weak var tempView: TappableStackView!
	@IBOutlet weak var tempActLbl: StyledLabel!
	@IBOutlet weak var tempMinLbl: StyledLabel!
	@IBOutlet weak var tempMaxLbl: StyledLabel!

	@IBOutlet weak var weatherPlaceholder: UIView!
	fileprivate var weather: WeatherVC!

	@IBOutlet weak var infoView: TappableStackView!
	@IBOutlet weak var infoTextLbl: StyledLabel!
	@IBOutlet weak var infoCityLbl: StyledLabel!
	@IBOutlet weak var infoTimeLbl: StyledLabel!

	@IBOutlet weak var forecastView: UIStackView!
	fileprivate var forecasts = [ForecastVC]()

	fileprivate var introDone = false
	fileprivate var reopenedApp = false
	fileprivate var forceUpdate = false

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		layoutView()

		positionWeather()
		positionForecasts()

		initializeTapViews()

		setObservers()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		updateLocation()
	}

	func updateWeatherForced() {
		forceUpdate = true
		updateLocation()
	}

	func updateWeather() {
		infoTextLbl.text = MES_WEATHER
		WeatherService.inst.getData(nil, forced: forceUpdate)
		forceUpdate = false
	}

	func notifNoLocation() {
		infoTextLbl.text = ERR_LOCATE
	}

	func notifLocationNoAuth() {

		infoTextLbl.text = ERR_NOAUTH

		let alert = AlertVC()
		alert.configureLocationAlert()

		present(alert, animated: true, completion: nil)
	}

	func switchUnits() {
		UnitService.inst.switchUnit()
		displayWeather()
	}

	func displayWeather() {
		displayWeatherData(animated: false)
	}

	func displayWeatherAnimated() {
		let t: Double
		if reopenedApp {
			layoutForWeatherAnimations()
			t = 0.6
		} else {
			t = 0
		}

		let dispatchTime = DispatchTime.now() + Double(Int64(t * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
		DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
			self.displayWeatherData(animated: true)
		})
	}

	func appEnteredForeground() {
		reopenedApp = true
		updateLocation()
	}

	fileprivate func setObservers() {
		NotificationCenter.default.addObserver(self, selector: #selector(MainVC.updateWeather), name: NSNotification.Name(rawValue: Notification.locationAvailable.name), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(MainVC.notifNoLocation), name: NSNotification.Name(rawValue: Notification.locationUnavailable.name), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(MainVC.notifLocationNoAuth), name: NSNotification.Name(rawValue: Notification.locationAuthError.name), object: nil)

		NotificationCenter.default.addObserver(self, selector: #selector(MainVC.displayWeatherAnimated), name: NSNotification.Name(rawValue: Notification.weatherUpdated.name), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(MainVC.displayWeather), name: NSNotification.Name(rawValue: Notification.weatherOldData.name), object: nil)

		NotificationCenter.default.addObserver(self, selector: #selector(MainVC.switchUnits), name: NSNotification.Name(rawValue: Notification.userSwitchUnits.name), object: tempView)

		NotificationCenter.default.addObserver(self, selector: #selector(MainVC.updateWeatherForced), name: NSNotification.Name(rawValue: Notification.userUpdateLocation.name), object: infoView)

		NotificationCenter.default.addObserver(self, selector: #selector(MainVC.appEnteredForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: UIApplication.shared)
	}

	fileprivate func updateLocation() {
		if LocationService.inst.getLocation(forceUpdate) {
			weather.reset()
			infoTextLbl.text = MES_LOCATE
			infoCityLbl.text = nil
			infoTimeLbl.text = nil
			layoutForUpdate()
		}
	}

	fileprivate func initializeTapViews() {
		tempView.configureAction(trigger: .start, action: .userSwitchUnits)
		infoView.configureAction(trigger: .stop, action: .userUpdateLocation)
	}

	fileprivate func layoutView() {
		view.backgroundColor = WeatherService.inst.weather.bgColor
		view.backgroundGradient()
	}

	fileprivate func layoutForUpdate() {
		tempView.alpha = 0
		forecastView.alpha = 0
		weather.arrowView.alpha = 0
	}

	fileprivate func layoutForAnimations() {
		infoView.alpha = 0
		layoutForUpdate()
	}

	fileprivate func layoutForWeatherAnimations() {
		weatherPlaceholder.alpha = 0
		layoutForAnimations()
	}

	fileprivate func updateWeatherAnimation() {
		layoutForWeatherAnimations()

		guard introDone else {
			let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
			DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
				self.updateWeatherAnimation()
			})
			return
		}

		let delayInc = 0.15
		let delayStyle = 1.0

		UIView.animate(withDuration: delayStyle, animations: {
			self.view.backgroundColor = WeatherService.inst.weather.bgColor
		})

		let dispatchTime = DispatchTime.now() + Double(Int64(delayStyle / 2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
		DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
			NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: Notification.updateStyles.name), object: nil)
		})

		UIView.animate(withDuration: 0.5, delay: delayInc * 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
			self.tempView.alpha = 1
		}) { _ in }

		UIView.animate(withDuration: 0.5, delay: delayInc * 1, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
			self.weatherPlaceholder.alpha = 1
		}) { _ in }

		UIView.animate(withDuration: 0.5, delay: delayInc * 2, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
			self.infoView.alpha = 1
		}) { _ in }

		UIView.animate(withDuration: 0.5, delay: delayInc * 3, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
			self.forecastView.alpha = 1
		}) { _ in }

		UIView.animate(withDuration: 0.5, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
			self.weather.arrowView.alpha = 1
		}) { _ in }
	}

	fileprivate func displayWeatherData(animated b: Bool) {
		if b {
			updateWeatherAnimation()
		}

		let w = WeatherService.inst.weather

		tempActLbl.text = w.degrees
		tempMinLbl.text = w.minDegr
		tempMaxLbl.text = w.maxDegr

		weather.initWithWeather(w)

		infoTextLbl.text = w.desc
		infoCityLbl.text = w.location
		infoTimeLbl.text = w.time

		weather.scrollView.activate()

		displayForecasts()
	}

	fileprivate func positionWeather() {
		weather = WeatherVC()

		weatherPlaceholder.addSubview(weather.view)
	}

	fileprivate func positionForecasts() {
		let fcount = UIScreen.main.bounds.width <= 320 ? 4 : 5

		for _ in 1 ... fcount {
			let fc = ForecastVC()
			forecasts.append(fc)
		}
	}

	fileprivate func displayForecasts() {
		for v in forecastView.subviews {
			forecastView.removeArrangedSubview(v)
		}

		for (i, fc) in forecasts.enumerated() {
			guard WeatherService.inst.forecasts.count > i else {
				continue
			}

			let forecast = WeatherService.inst.forecasts[i]

			forecastView.addArrangedSubview(fc.view)
			fc.initWithForecast(forecast)
		}
	}
}
