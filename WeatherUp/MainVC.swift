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
    
    @IBOutlet weak var infoTextLbl: H3Label!
    @IBOutlet weak var infoCityLbl: H5Label!
    @IBOutlet weak var infoTimeLbl: H6Label!
    
    @IBOutlet weak var stacker: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        stacker.addArrangedSubview(ForecastVC().view)
        stacker.addArrangedSubview(ForecastVC().view)
        stacker.addArrangedSubview(ForecastVC().view)
        stacker.addArrangedSubview(ForecastVC().view)
        stacker.addArrangedSubview(ForecastVC().view)
    }

}

