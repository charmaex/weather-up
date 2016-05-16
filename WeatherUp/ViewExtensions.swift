//
//  ViewExtensions.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 22.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

extension UILabel {
    
    func applyFontStyle(style: FontStyles, color: UIColor) {
        self.font = style.font()
        self.textColor = color
    }
    
}

extension UIView {
    
    private func addGradientLayer(colors: [CGColor]) {
        let gradient = CAGradientLayer()
        gradient.frame.size = self.frame.size
        gradient.frame.origin = CGPointMake(0.0,0.0)
        
        gradient.colors = colors
        self.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    func backgroundGradient() {
        self.addGradientLayer(Colors.backgroundGradient())
    }
    
}

extension String {
    
    func textColorFromWeatherCode() -> UIColor {
        switch self.removeRight(3) {
        case "01d", "02d", "10d":
            return Colors.textYellow()
        case "01n", "02n", "03d", "03n", "10n", "50d", "50n":
            return Colors.textGray()
        case "04d", "04n", "09d", "09n", "11d", "11n", "13d", "13n":
            return Colors.textDarkGray()
        default:
            return UIColor.whiteColor()
        }
    }
    
}
