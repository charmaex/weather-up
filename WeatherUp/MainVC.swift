//
//  MainVC.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 01.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    private let NOTIF_OBJECT: Notification.Listener = .MainVC
    
    @IBOutlet weak var introLogo: UILabel!
    @IBOutlet weak var introCloud1Disable: NSLayoutConstraint!
    @IBOutlet weak var introCloud2: NSLayoutConstraint!
    @IBOutlet weak var introCloud3: NSLayoutConstraint!
    @IBOutlet weak var introHill: NSLayoutConstraint!
    
    @IBOutlet weak var tempView: TappableStackView!
    @IBOutlet weak var tempActLbl: StyledLabel!
    @IBOutlet weak var tempMinLbl: StyledLabel!
    @IBOutlet weak var tempMaxLbl: StyledLabel!
    
    @IBOutlet weak var weatherPlaceholder: UIView!
    private var weather: WeatherVC!
    
    @IBOutlet weak var infoView: TappableStackView!
    @IBOutlet weak var infoTextLbl: StyledLabel!
    @IBOutlet weak var infoCityLbl: StyledLabel!
    @IBOutlet weak var infoTimeLbl: StyledLabel!
    
    @IBOutlet weak var forecastView: UIStackView!
    private var forecasts = [ForecastVC]()
    
    private var introDone = false
    private var reopenedApp = false
    private var forceUpdate = false
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutView()
        
        positionWeather()
        positionForecasts()
        
        initializeTapViews()
        
        setObservers()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        introAnimation(delayed: 0.3)
        
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
        
        presentViewController(alert, animated: true, completion: nil)
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
        
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(t * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.displayWeatherData(animated: true)
        })
    }
    
    func appEnteredForeground() {
        reopenedApp = true
        updateLocation()
    }
    
    private func setObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainVC.updateWeather), name: Notification.LocationAvailable.name, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainVC.notifNoLocation), name: Notification.LocationUnavailable.name, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainVC.notifLocationNoAuth), name: Notification.LocationAuthError.name, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainVC.displayWeatherAnimated), name: Notification.WeatherUpdated.name, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainVC.displayWeather), name: Notification.WeatherOldData.name, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainVC.switchUnits), name: Notification.UserSwitchUnits.name, object: NOTIF_OBJECT.object)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainVC.updateWeatherForced), name: Notification.UserUpdateLocation.name, object: NOTIF_OBJECT.object)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainVC.appEnteredForeground), name: UIApplicationWillEnterForegroundNotification, object: UIApplication.sharedApplication())
    }
    
    private func introAnimation(delayed t: Double) {
        layoutForAnimations()
        
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(t * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.introAnimation()
        })
    }
    
    private func introAnimation() {
        layoutForAnimations()
        
        introCloud1Disable.active = false
        introCloud2.constant = -240
        introCloud3.constant = -240
        introHill.constant = -200
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .CurveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.introLogo.alpha = 0
            }) { b in
                self.introDone = b
        }
        
        UIView.animateWithDuration(0.5, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .CurveEaseOut, animations: {
            self.infoView.alpha = 1
        }) { _ in }
        
    }
    
    private func updateLocation() {
        if LocationService.inst.getLocation(forceUpdate) {
            weather.reset()
            infoTextLbl.text = MES_LOCATE
            infoCityLbl.text = nil
            infoTimeLbl.text = nil
            layoutForUpdate()
        }
    }
    
    private func initializeTapViews() {
        tempView.configureAction(trigger: .Start, action: .UserSwitchUnits, listener: NOTIF_OBJECT)
        infoView.configureAction(trigger: .Stop, action: .UserUpdateLocation, listener: NOTIF_OBJECT)
    }
    
    private func layoutView() {
        view.backgroundColor = WeatherService.inst.weather.bgColor
        view.backgroundGradient()
    }
    
    private func layoutForUpdate() {
        tempView.alpha = 0
        forecastView.alpha = 0
        weather.arrowView.alpha = 0
    }
    
    private func layoutForAnimations() {
        infoView.alpha = 0
        layoutForUpdate()
    }
    
    private func layoutForWeatherAnimations() {
        weatherPlaceholder.alpha = 0
        layoutForAnimations()
    }
    
    private func updateWeatherAnimation() {
        layoutForWeatherAnimations()
        
        guard introDone else {
            let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                self.updateWeatherAnimation()
            })
            return
        }
        
        let delayInc = 0.15
        let delayStyle = 1.0
        
        UIView.animateWithDuration(delayStyle) {
            self.view.backgroundColor = WeatherService.inst.weather.bgColor
        }
        
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayStyle / 2 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            NSNotificationCenter.defaultCenter().postNotificationName(Notification.UpdateStyles.name, object: nil)
        })
        
        UIView.animateWithDuration(0.5, delay: delayInc * 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .CurveEaseOut, animations: {
            self.tempView.alpha = 1
        }) { _ in }
        
        UIView.animateWithDuration(0.5, delay: delayInc * 1, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .CurveEaseOut, animations: {
            self.weatherPlaceholder.alpha = 1
        }) { _ in }
        
        UIView.animateWithDuration(0.5, delay: delayInc * 2, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .CurveEaseOut, animations: {
            self.infoView.alpha = 1
        }) { _ in }
        
        UIView.animateWithDuration(0.5, delay: delayInc * 3, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .CurveEaseOut, animations: {
            self.forecastView.alpha = 1
        }) { _ in }
        
        UIView.animateWithDuration(0.5, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .CurveEaseOut, animations: {
            self.weather.arrowView.alpha = 1
        }) { _ in }
    }
    
    private func displayWeatherData(animated b: Bool) {
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
    
    private func positionWeather() {
        weather = WeatherVC()
        
        weatherPlaceholder.addSubview(weather.view)
    }
    
    private func positionForecasts() {
        let fcount = UIScreen.mainScreen().bounds.width <= 320 ? 4 : 5
        
        for _ in 1...fcount {
            let fc = ForecastVC()
            forecasts.append(fc)
            forecastView.addArrangedSubview(fc.view)
        }
    }
    
    private func displayForecasts() {
        for (i, fc) in forecasts.enumerate() {
            guard WeatherService.inst.forecasts.count > i else {
                continue
            }
            let forecast = WeatherService.inst.forecasts[i]
            fc.initWithForecast(forecast)
        }
    }

}
