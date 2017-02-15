//
//  TappableStackView.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 28.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class TappableStackView: UIStackView {

	fileprivate var trigger: Trigger = .none
	fileprivate var notification: Notifications!

	enum Trigger {
		case none
		case start
		case startAndStop
		case stop
	}

	func configureAction(trigger: Trigger, action notification: Notifications) {
		self.trigger = trigger
		self.notification = notification
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if trigger != .none {
			alpha = 0.5
		}

		if trigger == .start || trigger == .startAndStop {
			postNotif()
		}
	}

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		alpha = 1

		guard let position = getPosition(touches, absolutePosition: false) else {
			return
		}

		if frame.contains(position) {
			if trigger == .stop || trigger == .startAndStop {
				postNotif()
			}
		}
	}

	fileprivate func postNotif() {
		guard trigger != .none else {
			return
		}

		NotificationCenter.default.post(name: notification.name, object: self)
	}

	fileprivate func getPosition(_ input: Set<UITouch>, absolutePosition: Bool) -> CGPoint? {
		guard let touch = input.first else {
			return nil
		}

		if absolutePosition {
			return touch.location(in: super.superview?.superview)
		}

		return touch.location(in: super.superview)
	}
}
