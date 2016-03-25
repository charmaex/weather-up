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
    @IBOutlet weak var tempLowLbl: ParagraphLabel!
    @IBOutlet weak var tempHighLbl: ParagraphLabel!
    
    @IBOutlet weak var weatherPlaceholder: UIView!
    
    @IBOutlet weak var infoView: UIStackView!
    @IBOutlet weak var infoTextLbl: H3Label!
    @IBOutlet weak var infoCityLbl: H5Label!
    @IBOutlet weak var infoTimeLbl: H6Label!
    
    @IBOutlet weak var forecastView: UIStackView!
    var forecast1: ForecastVC!
    var forecast2: ForecastVC!
    var forecast3: ForecastVC!
    var forecast4: ForecastVC!
    var forecast5: ForecastVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoView.hidden = UIScreen.mainScreen().bounds.height <= 480
        
        createForecasts()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainVC.updateWeather), name: "locationIsAvailable", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainVC.locationNoAuth), name: "locationAuthError", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        LocationService.inst.getLocation()
    }
    
    func updateWeather() {
        WeatherService.inst.getData(nil)
    }
    
    func locationNoAuth() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings.", preferredStyle: .Alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .Default) { (UIAlertAction) in
            self.openPref()
        }
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(okAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func openPref() {
        let url = NSURL(string: "prefs:root=LOCATION_SERVICES")!
        
        UIApplication.sharedApplication().openURL(url)
    }
    
    func createForecasts() {
        forecast1 = ForecastVC()
        forecastView.addArrangedSubview(forecast1.view)
        
        forecast2 = ForecastVC()
        forecastView.addArrangedSubview(forecast2.view)
        
        forecast3 = ForecastVC()
        forecastView.addArrangedSubview(forecast3.view)
        
        forecast4 = ForecastVC()
        forecastView.addArrangedSubview(forecast4.view)
        
        if UIScreen.mainScreen().bounds.width > 320 {
            forecast5 = ForecastVC()
            forecastView.addArrangedSubview(forecast5!.view)
        }
    }

}

