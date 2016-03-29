//
//  ViewExtensions.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 22.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func applyStyle(style: FontStyles) {
        self.font = style.font()
        self.textColor = style.color()
    }
    
}

extension UIView {
    
    func layerGradient(colors: [CGColor]) {
        let layer = CAGradientLayer()
        layer.frame.size = self.frame.size
        layer.frame.origin = CGPointMake(0.0,0.0)
        
        layer.colors = colors
        self.layer.insertSublayer(layer, atIndex: 0)
    }
    
    func backgroundGradient() {
        self.layerGradient(Colors.backgroundGradient())
    }
    
}
