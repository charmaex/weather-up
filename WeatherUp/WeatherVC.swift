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
    
    @IBOutlet weak var weatherConstraint: NSLayoutConstraint!
    @IBOutlet weak var weatherSV: UIStackView!
    @IBOutlet weak var weatherImV: UIImageView!
    @IBOutlet weak var weatherLbl: ParagraphLabel!
    
    @IBOutlet weak var infoConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoSV: UIStackView!
    
    private var screenWidth: CGFloat!
    private var spacing: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        infoSV.alpha = 0
        
        screenWidth = UIScreen.mainScreen().bounds.width
        spacing = (screenWidth - 160) / 2
        
        weatherConstraint.constant = spacing
        infoConstraint.constant = spacing
        
        let viewWidth = screenWidth * 2 - spacing + 20
        
        view.frame = CGRectMake(0, 0, viewWidth, 184)
        
        scrollView.delegate = self
        
    }

    func initWithWeather(w: Weather) {
        let img = UIImage(named: w.imageName)
        
        weatherImV.image = img
        weatherLbl.text = w.mainDesc
    }
    
}
