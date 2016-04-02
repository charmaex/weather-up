//
//  ArrowView.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 29.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

@IBDesignable
class ArrowView: UIView {
    
    @IBInspectable var test: CGFloat = 1 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        WeatherUpKit.drawCanvas1(frame: self.bounds, arrowColor: Colors.arrowColor(), arrowValue: test)
        
    }
    
}
