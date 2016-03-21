//
//  Styles.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 20.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation
import UIKit

class ColorPalette {
    
    class func textColor() -> UIColor {
        return rgba(108, 244, 255, 1)
    }
    
}


enum Fonts: String {
    
    case GillSans
    
    enum Weights: String {
        case Regular = ""
        case Italic = "-Italic"
        case Light = "-Light"
    }
    
}

    
enum FontStyles {
    
    case H1, H2, H3, Paragraph, H6, TextStyle
    
    func color() -> UIColor {
        switch self {
        default:
            return ColorPalette.textColor()
        }
    }
    
    func font() -> UIFont {
        switch self {
        case .H1:
            return UIFont(name: Fonts.GillSans.name(weight: .Regular), size: 12)!
        case .H2:
            return UIFont(name: Fonts.GillSans.name(weight: .Italic), size: 12)!
        case .H3:
            return UIFont(name: Fonts.GillSans.name(weight: .Light), size: 12)!
        case .Paragraph:
            return UIFont(name: Fonts.GillSans.name(weight: .Regular), size: 12)!
        case .H6:
            return UIFont(name: Fonts.GillSans.name(weight: .Regular), size: 12)!
        case .TextStyle:
            return UIFont(name: Fonts.GillSans.name(weight: .Regular), size: 12)!
        }
    }
    
}


// supporting extensions

extension UILabel {
    func applyStyle(style: FontStyles) {
        self.font = style.font()
        self.textColor = style.color()
    }
}

extension ColorPalette {
    private class func rgba(r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
}

extension Fonts {
    func name(weight weight: Weights) -> String {
        return "\(self.rawValue)\(weight.rawValue)"
    }
}
