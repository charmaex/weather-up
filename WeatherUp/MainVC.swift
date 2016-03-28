//
//  MainVC.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 01.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
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
        
        view.backgroundGradient()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainVC.updateWeather), name: "locationIsAvailable", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainVC.noLocation), name: "locationIsNotAvailable", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainVC.locationNoAuth), name: "locationAuthError", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainVC.displayWeather), name: "gotWeatherData", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainVC.updateLocation), name: UIApplicationWillEnterForegroundNotification, object: UIApplication.sharedApplication())
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateLocation()
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
    
    func displayWeather() {
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
