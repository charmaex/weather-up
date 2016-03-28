//
//  WeatherVC.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 26.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class WeatherVC: UIViewController {
    
    @IBOutlet weak var scrollView: ScrollingView!
    @IBOutlet weak var svLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var svRightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var weatherConstraint: NSLayoutConstraint!
    @IBOutlet weak var weatherSV: UIStackView!
    @IBOutlet weak var weatherImV: UIImageView!
    @IBOutlet weak var weatherLbl: ParagraphLabel!
    
    //replace with native animation
    @IBOutlet weak var leftArrow: UIImageView!
    @IBOutlet weak var rightArrow: UIImageView!
    
    @IBOutlet weak var infoConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoSV: UIStackView!
    @IBOutlet weak var cloudsLbl: ParagraphRightLabel!
    @IBOutlet weak var rainLbl: ParagraphRightLabel!
    @IBOutlet weak var windLbl: ParagraphRightLabel!
    @IBOutlet weak var pressureLbl: ParagraphRightLabel!
    @IBOutlet weak var humidityLbl: ParagraphRightLabel!
    
    private var screenWidth: CGFloat!
    private var spacing: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftArrow.alpha = 0
        infoSV.alpha = 0
        
        screenWidth = UIScreen.mainScreen().bounds.width
        spacing = (screenWidth - 160) / 2
        
        weatherConstraint.constant = spacing
        infoConstraint.constant = spacing
        
        scrollView.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let viewWidth = screenWidth * 2 - spacing + 20
        
        view.frame = CGRectMake(0, 0, viewWidth, 184)
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.positionView()
    }

    func initWithWeather(w: Weather) {
        let img = UIImage(named: w.imageName)
        
        weatherImV.image = img
        weatherLbl.text = w.mainDesc
        
        cloudsLbl.text = w.clouds
        rainLbl.text = w.rain
        windLbl.text = w.wind
        pressureLbl.text = w.pressure
        humidityLbl.text = w.humidity
    }
    
}
