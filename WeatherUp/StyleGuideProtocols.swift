//
//  StyleGuideProtocols.swift
//
//  Created by Jan Dammshäuser on 22.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

protocol FontList {
    func name(weight weight: FontWeights) -> String
}

extension FontList {
    func name(weight weight: FontWeights) -> String {
        return "\(self)\(weight.rawValue)"
    }
}


protocol ColorPalette {
    static func rgba(r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor
}

extension ColorPalette {
    static func rgba(r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
}


protocol FontStylesList {
    func color() -> UIColor
    func font() -> UIFont
}


enum FontWeights: String {
    case Regular = ""
    case Italic = "-Italic"
    case Light = "-Light"
}
