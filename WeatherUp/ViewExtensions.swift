//
//  ViewExtensions.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 22.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func applyStyle(style: Styles) {
        self.font = style.font()
        self.textColor = style.color()
    }
}