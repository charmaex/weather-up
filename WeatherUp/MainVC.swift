//
//  MainVC.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 01.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var introLogo: UILabel!
    @IBOutlet weak var introCloud1Disable: NSLayoutConstraint!
    @IBOutlet weak var introCloud2: NSLayoutConstraint!
    @IBOutlet weak var introCloud3: NSLayoutConstraint!
    @IBOutlet weak var introHill: NSLayoutConstraint!
    
    @IBOutlet weak var tempView: TappableStackView!
    @IBOutlet weak var tempActLbl: H1Label!
    @IBOutlet weak var tempMinLbl: ParagraphLabel!
    @IBOutlet weak var tempMaxLbl: ParagraphLabel!
    
    @IBOutlet weak var weatherPlaceholder: UIView!
    var weather: WeatherVC!
    
    @IBOutlet weak var infoView: UIStackView!
    @IBOutlet weak var infoTextLbl: H3Label!
    @IBOutlet weak var infoCityLbl: H5Label!
    @IBOutlet weak var infoTimeLbl: H6Label!
    
    @IBOutlet weak var forecastView: UIStackView!
    var forecasts = [ForecastVC]()
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoView.hidden = UIScreen.mainScreen().bounds.height <= 480
        
        positionWeather()
        createForecasts()
        
        tempView.delegate = self
        
        view.backgroundGradient()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainVC.updateWeather), name: "locationIsAvailable", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainVC.noLocation), name: "locationIsNotAvailable", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainVC.locationNoAuth), name: "locationAuthError", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainVC.displayWeather), name: "gotWeatherData", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainVC.updateLocation), name: UIApplicationWillEnterForegroundNotification, object: UIApplication.sharedApplication())
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        introAnimation()
        updateLocation()
    }
    
    func introAnimation() {
        infoTextLbl.alpha = 0
        introCloud1Disable.active = false
        introCloud2.constant = -240
        introCloud3.constant = -240
        introHill.constant = -200
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .CurveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.introLogo.alpha = 0
            }) { _ in }
        
        UIView.animateWithDuration(0.5, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .CurveEaseOut, animations: { 
            self.infoTextLbl.alpha = 1
            }) { _ in }
    }
    
    func updateWeatherAnimation() {
        tempView.alpha = 0
        weatherPlaceholder.alpha = 0
        infoView.alpha = 0
        forecastView.alpha = 0
        
        
    }
    
    func updateLocation() {
        if LocationService.inst.getLocation() {
            infoTextLbl.text = MES_LOCATE
        }
    }
    
    func updateWeather() {
        infoTextLbl.text = MES_WEATHER
        WeatherService.inst.getData(nil)
    }
    
    func switchUnits() {
        UnitService.inst.switchUnit()
        displayWeather()
    }
    
    func displayWeather() {
        updateWeatherAnimation()
        
        let w = WeatherService.inst.weather
        
        tempActLbl.text = w.degrees
        tempMinLbl.text = w.minDegr
        tempMaxLbl.text = w.maxDegr

        weather.initWithWeather(w)

        infoTextLbl.text = w.desc
        infoCityLbl.text = w.location
        infoTimeLbl.text = w.time

        fillForecasts()
    }
    
    func noLocation() {
        infoTextLbl.text = ERR_LOCATE
    }
    
    func locationNoAuth() {
        
        infoTextLbl.text = ERR_NOAUTH
        
        let alert = AlertVC()
        alert.configureLocationAlert()
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func positionWeather() {
        weather = WeatherVC()
        
        weatherPlaceholder.addSubview(weather.view)
    }
    
    func createForecasts() {
        let fcount = UIScreen.mainScreen().bounds.width <= 320 ? 4 : 5
        
        for _ in 1...fcount {
            let fc = ForecastVC()
            forecasts.append(fc)
            forecastView.addArrangedSubview(fc.view)
        }
    }
    
    func fillForecasts() {
        for (i, fc) in forecasts.enumerate() {
            let forecast = WeatherService.inst.forecasts[i]
            fc.initWithForecast(forecast)
        }
    }

}
