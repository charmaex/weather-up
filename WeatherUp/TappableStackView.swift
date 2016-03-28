//
//  TappableStackView.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 28.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class TappableStackView: UIStackView {
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        alpha = 0.8
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        alpha = 1
    }
    
}
