//
//  ViewExtensions.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 22.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

extension UILabel {
    
    func applyFontStyle(_ style: FontStyles, color: UIColor) {
        self.font = style.font()
        self.textColor = color
    }
    
}

extension UIView {
    
    fileprivate func addGradientLayer(_ colors: [CGColor]) {
        let gradient = CAGradientLayer()
        gradient.frame.size = self.frame.size
        gradient.frame.origin = CGPoint(x: 0.0,y: 0.0)
        
        gradient.colors = colors
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func backgroundGradient() {
        self.addGradientLayer(Colors.backgroundGradient())
    }
    
}
