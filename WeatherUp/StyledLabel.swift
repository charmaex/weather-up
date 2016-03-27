//
//  StyledLabel.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 22.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class StyledLabel: UILabel {
    private var style: FontStyles?
    
    override func awakeFromNib() {
        guard let style = style else {
            return
        }
        self.applyStyle(style)
        self.minimumScaleFactor = 0.8
        self.textAlignment = .Center
    }
}

class H1Label: StyledLabel {
    
    override func awakeFromNib() {
        style = .H1
        super.awakeFromNib()
    }

}

class H2Label: StyledLabel {
    
    override func awakeFromNib() {
        style = .H2
        super.awakeFromNib()
    }
    
}

class H3Label: StyledLabel {
    
    override func awakeFromNib() {
        style = .H3
        super.awakeFromNib()
    }
}

class ParagraphLabel: StyledLabel {
    
    override func awakeFromNib() {
        style = .Paragraph
        super.awakeFromNib()
    }
}

class ParagraphLeftLabel: ParagraphLabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textAlignment = .Left
    }
}

class ParagraphRightLabel: ParagraphLabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textAlignment = .Right
    }
}

class H5Label: StyledLabel {
    
    override func awakeFromNib() {
        style = .H5
        super.awakeFromNib()
    }
}

class H6Label: StyledLabel {
    
    override func awakeFromNib() {
        style = .H6
        super.awakeFromNib()
    }
}

class TextStyleLabel: StyledLabel {
    
    override func awakeFromNib() {
        style = .TextStyle
        super.awakeFromNib()
    }
}
