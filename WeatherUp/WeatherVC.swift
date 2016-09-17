//
//  WeatherVC.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 26.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class WeatherVC: UIViewController, ScrollingViewDelegate {
    
    @IBOutlet weak var scrollView: ScrollingView!
    @IBOutlet weak var svLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var svRightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var weatherConstraint: NSLayoutConstraint!
    @IBOutlet weak var weatherSV: UIStackView!
    @IBOutlet weak var weatherImV: UIImageView!
    @IBOutlet weak var weatherLbl: StyledLabel!
    
    @IBOutlet weak var arrowView: ArrowView!
    
    @IBOutlet weak var infoConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoSV: UIStackView!
    @IBOutlet weak var cloudsLbl: StyledLabel!
    @IBOutlet weak var rainLbl: StyledLabel!
    @IBOutlet weak var windLbl: StyledLabel!
    @IBOutlet weak var pressureLbl: StyledLabel!
    @IBOutlet weak var humidityLbl: StyledLabel!
    
    fileprivate var screenWidth: CGFloat!
    fileprivate var spacing: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        initializeView()
        setViewWidth()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.positionView()
    }

    func scrollingView(leftAlpha left: CGFloat, MoveWithRightAlpha right: CGFloat, arrow: CGFloat) {
        weatherSV.alpha = left
        infoSV.alpha = right
        arrowView.fraction = arrow
    }
    
    func reset() {
        defaultImage()
        weatherLbl.alpha = 0
        scrollView.reset()
    }
    
    func initWithWeather(_ w: Weather) {
        let img = UIImage(named: w.imageName)
        
        weatherImV.image = img
        weatherLbl.text = w.mainDesc
        weatherLbl.alpha = 1
        
        cloudsLbl.text = w.clouds
        rainLbl.text = w.rain
        windLbl.text = w.wind
        pressureLbl.text = w.pressure
        humidityLbl.text = w.humidity
    }
    
    fileprivate func setViewWidth() {
        let viewWidth = screenWidth * 2 - spacing + 20
        
        view.frame = CGRect(x: 0, y: 0, width: viewWidth, height: 184)
    }
    
    fileprivate func defaultImage() {
        let img = UIImage(named: "01d160")
        
        weatherImV.image = img
    }
    
    fileprivate func initializeView() {
        infoSV.alpha = 0
        
        screenWidth = UIScreen.main.bounds.width
        spacing = (screenWidth - 160) / 2
        
        weatherConstraint.constant = spacing
        infoConstraint.constant = spacing
    }
    
    fileprivate func setDelegates() {
        scrollView.delegate = self
    }
    
}
