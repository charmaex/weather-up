//
//  Styles.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 20.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class Colors: ColorPalette {
    
    class func backgroundFreeze() -> UIColor {
        return rgba(16, 96, 188, 1)
    }
    
    class func backgroundCold() -> UIColor {
        return rgba(16, 188, 182, 1)
    }
    
    class func backgroundModerate() -> UIColor {
        return rgba(39, 181, 16, 1)
    }
    
    class func backgroundWarm() -> UIColor {
        return rgba(188, 79, 16, 1)
    }
    
    class func backgroundHot() -> UIColor {
        return rgba(188, 16, 16, 1)
    }
    
    class func textColor() -> UIColor {
        return rgba(255, 255, 255, 1)
    }
    
    class func backgroundGradient() -> [CGColor] {
        var out = [CGColor]()
        
        out.append(UIColor.clear.cgColor)
        out.append(UIColor.black.withAlphaComponent(0.5).cgColor)
        
        return out
    }
    
}


enum Fonts: FontList {
    
    case gillSans
    
}


enum FontStyles: String, FontStylesList {
    
    case H1, H2, H3, Paragraph, H5, H6, TextStyle
    
    func font() -> UIFont {
        switch self {
        case .H1:
            return UIFont(name: Fonts.gillSans.name(weight: .Light), size: 94)!
        case .H2:
            return UIFont(name: Fonts.gillSans.name(weight: .Italic), size: 36)!
        case .H3:
            return UIFont(name: Fonts.gillSans.name(weight: .Regular), size: 14)!
        case .Paragraph:
            return UIFont(name: Fonts.gillSans.name(weight: .Italic), size: 14)!
        case .H5:
            return UIFont(name: Fonts.gillSans.name(weight: .Italic), size: 12)!
        case .H6:
            return UIFont(name: Fonts.gillSans.name(weight: .Regular), size: 11)!
        case .TextStyle:
            return UIFont(name: Fonts.gillSans.name(weight: .Regular), size: 10)!
        }
    }
    
}
