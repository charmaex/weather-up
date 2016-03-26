//
//  ForecastVC.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 22.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class ForecastVC: UIViewController {
    
    @IBOutlet weak var dayLbl: H6Label!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var degreesLbl: H5Label!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initWithForecast(f: Forecast) {
        let img = UIImage(named: f.imageName)
        
        dayLbl.text = f.weekday
        weatherImg.image = img
        degreesLbl.text = f.degrees(unit: .Celsius)
    }

}
