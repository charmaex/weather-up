//
//  Styles.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 20.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation
import UIKit

class Colors: ColorPalette {
    
    class func textColor() -> UIColor {
        return rgba(108, 244, 255, 1)
    }
    
    class func arrowColor() -> UIColor {
        return rgba(108, 244, 255, 0.6)
    }
    
    class func gradientTop() -> UIColor {
        return rgba(52, 100, 143, 1)
    }
    
    class func background() -> UIColor {
        return rgba(24, 53, 86, 1)
    }
    
    class func gradientColors() -> [CGColor] {
        var out = [CGColor]()
        
        out.append(gradientTop().CGColor)
        out.append(UIColor.clearColor().CGColor)
        
        return out
    }
    
}


enum Fonts: FontList {
    
    case GillSans
    
}


enum FontStyles: FontStylesList {
    
    case H1, H2, H3, Paragraph, H5, H6, TextStyle
    
    func color() -> UIColor {
        switch self {
        default:
            return Colors.textColor()
        }
    }
    
    func font() -> UIFont {
        switch self {
        case .H1:
            return UIFont(name: Fonts.GillSans.name(weight: .Light), size: 94)!
        case .H2:
            return UIFont(name: Fonts.GillSans.name(weight: .Italic), size: 36)!
        case .H3:
            return UIFont(name: Fonts.GillSans.name(weight: .Regular), size: 14)!
        case .Paragraph:
            return UIFont(name: Fonts.GillSans.name(weight: .Italic), size: 14)!
        case .H5:
            return UIFont(name: Fonts.GillSans.name(weight: .Italic), size: 12)!
        case .H6:
            return UIFont(name: Fonts.GillSans.name(weight: .Regular), size: 11)!
        case .TextStyle:
            return UIFont(name: Fonts.GillSans.name(weight: .Regular), size: 10)!
        }
    }
    
}
