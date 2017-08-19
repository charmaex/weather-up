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

	var forecast: Forecast?

	@IBInspectable var style: String = "TextStyle"
	@IBInspectable var orientation: String = "Center"

	fileprivate enum Orientation: String {
		case left, center, right
	}

	func orientationStyle() -> NSTextAlignment {
		guard let orient = Orientation(rawValue: orientation),
			let x = NSTextAlignment(rawValue: orient.hashValue) else {
			return .center
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
		setObservers()
	}

	override func prepareForInterfaceBuilder() {
		styleLabel()
	}

	fileprivate func styleLabel() {
		self.applyTextColor()
		self.minimumScaleFactor = 0.8
		self.textAlignment = orientationStyle()
	}

	@objc func applyTextColor() {
		let color = forecast?.textColor ?? WeatherService.inst.weather.textColor
		applyFontStyle(fontStyle(), color: color)
	}

	func setObservers() {
		NotificationCenter.default.addObserver(self, selector: #selector(StyledLabel.applyTextColor), name: Notifications.updateStyles.name, object: nil)
	}
}
