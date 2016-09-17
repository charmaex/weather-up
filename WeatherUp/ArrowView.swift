//
//  ArrowView.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 29.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

@IBDesignable
class ArrowView: UIView {

	@IBInspectable var fraction: CGFloat = 1 {
		didSet {
			setNeedsDisplay()
		}
	}

	override func awakeFromNib() {
		setObservers()
	}

	override func draw(_ rect: CGRect) {

		WeatherUpKit.drawCanvas1(frame: self.bounds, arrowColor: WeatherService.inst.weather.textColor, arrowValue: fraction)
	}

	func updateColor() {
		setNeedsDisplay()
	}

	func setObservers() {
		NotificationCenter.default.addObserver(self, selector: #selector(ArrowView.updateColor), name: NSNotification.Name(rawValue: Notification.updateStyles.name), object: nil)
	}
}
