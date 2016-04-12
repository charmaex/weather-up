//
//  StyledLabel.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 22.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

@IBDesignable
class StyledLabel: UILabel {
    
    @IBInspectable var style: String = "TextStyle"
    @IBInspectable var orientation: String = "Center"
    
    private enum Orientation: String {
        case Left, Center, Right
    }
    
    func orientationStyle() -> NSTextAlignment {
        guard let orient = Orientation(rawValue: orientation),
              let x = NSTextAlignment(rawValue: orient.hashValue) else {
            return .Center
        }
        
        return x
    }
    
    func fontStyle() -> FontStyles {
        guard let x = FontStyles(rawValue: style) else {
            return .TextStyle
        }
        
        return x
    }
    
    override func awakeFromNib() {
        styleLabel()
    }
    
    override func prepareForInterfaceBuilder() {
        styleLabel()
    }
    
    private func styleLabel() {
        self.applyFontStyle(fontStyle())
        self.minimumScaleFactor = 0.8
        self.textAlignment = orientationStyle()
    }
}
