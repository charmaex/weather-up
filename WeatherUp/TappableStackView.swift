//
//  TappableStackView.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 28.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

protocol TappableStackViewDelegate {
    func switchUnits()
}

class TappableStackView: UIStackView {
    
    var delegate: TappableStackViewDelegate!
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        alpha = 0.5
        delegate.switchUnits()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        alpha = 1
    }
    
}
