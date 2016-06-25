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
    
    private var screenWidth: CGFloat!
    private var spacing: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
    }
    
    override func viewDidAppear(animated: Bool) {
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
    
    func initWithWeather(w: Weather) {
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
    
    private func setViewWidth() {
        let viewWidth = screenWidth * 2 - spacing + 20
        
        view.frame = CGRectMake(0, 0, viewWidth, 184)
    }
    
    private func defaultImage() {
        let img = UIImage(named: "01d160")
        
        weatherImV.image = img
    }
    
    private func initializeView() {
        infoSV.alpha = 0
        
        screenWidth = UIScreen.mainScreen().bounds.width
        spacing = (screenWidth - 160) / 2
        
        weatherConstraint.constant = spacing
        infoConstraint.constant = spacing
    }
    
    private func setDelegates() {
        scrollView.delegate = self
    }
    
}
