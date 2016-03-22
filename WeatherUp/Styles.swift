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
    
}


enum Fonts: FontList {
    
    case GillSans
    
}


enum FontStyles: FontStylesList {
    
    case H1, H2, H3, Paragraph, H5, H6
    
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
        }
    }
    
}
