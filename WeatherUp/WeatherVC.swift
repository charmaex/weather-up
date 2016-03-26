//
//  WeatherVC.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 26.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class WeatherVC: UIViewController {

    @IBOutlet weak var weatherImV: UIImageView!
    @IBOutlet weak var weatherLbl: ParagraphLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func initWithWeather(w: Weather) {
        let img = UIImage(named: w.imageName)
        
        weatherImV.image = img
        weatherLbl.text = w.mainDesc
    }

}
