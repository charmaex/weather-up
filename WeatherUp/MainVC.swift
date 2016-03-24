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
        
        LocationService.inst.getLocation()
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

