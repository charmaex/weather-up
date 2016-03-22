//
//  StyledLabel.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 22.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class H1Label: UILabel {
    
    let style: FontStyles = .H1
    
    override func awakeFromNib() {
        self.applyStyle(style)
    }

}

class H2Label: UILabel {
    
    let style: FontStyles = .H2
    
    override func awakeFromNib() {
        self.applyStyle(style)
    }
    
}

class H3Label: UILabel {
    
    let style: FontStyles = .H3
    
    override func awakeFromNib() {
        self.applyStyle(style)
    }
    
}

class ParagraphLabel: UILabel {
    
    let style: FontStyles = .Paragraph
    
    override func awakeFromNib() {
        self.applyStyle(style)
    }
    
}

class H6Label: UILabel {
    
    let style: FontStyles = .H6
    
    override func awakeFromNib() {
        self.applyStyle(style)
    }
    
}

class TextStyleLabel: UILabel {
    
    let style: FontStyles = .TextStyle
    
    override func awakeFromNib() {
        self.applyStyle(style)
    }
    
}