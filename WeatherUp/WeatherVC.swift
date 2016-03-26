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
    @IBOutlet weak var weatherImV: UIImageView!
    @IBOutlet weak var weatherLbl: ParagraphLabel!
    
    @IBOutlet weak var weatherConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoConstraint: NSLayoutConstraint!
    
    private var screenWidth: CGFloat!
    private var frameWidth: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenWidth = UIScreen.mainScreen().bounds.width
        frameWidth = (screenWidth - 160) / 2
        
        weatherConstraint.constant = frameWidth
        infoConstraint.constant = frameWidth
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width = screenWidth * 2 - frameWidth + 20
        
        view.frame = CGRectMake(0, 0, width, 184)
        
    }

    func initWithWeather(w: Weather) {
        let img = UIImage(named: w.imageName)
        
        weatherImV.image = img
        weatherLbl.text = w.mainDesc
    }
    
}
