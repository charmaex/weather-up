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
    @IBOutlet weak var infoCityLbl: H6Label!
    @IBOutlet weak var infoTimeLbl: TextStyleLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

}

