//
//  Styles.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 20.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func applyStyle(style: FontStyles) {
        let (font, color) = style.getStyle()
        
        self.font = font
        self.textColor = color
    }
}

class ColorPalette: UIColor {
    
    class func textColor() -> UIColor {
        return rgba(108, 244, 255, 1)
    }
    
    private class func rgba(r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
}

enum Fonts: String {
    
    case GillSans
    
    enum FontType: String {
        case Regular = ""
        case Italic = "-Italic"
        case Light = "-Light"
    }
    
    func name(type: FontType) -> String {
        return "\(self.rawValue)\(type.rawValue)"
    }
    
}

enum FontStyles {
    
    case H1, H2, H3, Paragraph, H6, TextStyle
    
    func getStyle() -> (UIFont, UIColor) {
        return (font(), color())
    }
    
    private func color() -> UIColor {
        switch self {
        default:
            return ColorPalette.textColor()
        }
    }
    
    private func font() -> UIFont {
        switch self {
        case .H1:
            return UIFont(name: Fonts.GillSans.name(.Regular), size: 12)!
        case .H2:
            return UIFont(name: Fonts.GillSans.name(.Italic), size: 12)!
        case .H3:
            return UIFont(name: Fonts.GillSans.name(.Light), size: 12)!
        case .Paragraph:
            return UIFont(name: Fonts.GillSans.name(.Regular), size: 12)!
        case .H6:
            return UIFont(name: Fonts.GillSans.name(.Regular), size: 12)!
        case .TextStyle:
            return UIFont(name: Fonts.GillSans.name(.Regular), size: 12)!
        }
    }
    
}
