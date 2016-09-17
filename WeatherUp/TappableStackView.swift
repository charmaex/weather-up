//
//  TappableStackView.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 28.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class TappableStackView: UIStackView {

	fileprivate var _trigger: Trigger = .none
	fileprivate var _notifName: Notification!
	fileprivate var _object: Notification.Listener!

	enum Trigger {
		case none
		case start
		case startAndStop
		case stop
	}

	func configureAction(trigger t: Trigger, action n: Notification, listener o: Notification.Listener) {
		_trigger = t
		_notifName = n
		_object = o
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if _trigger != .none {
			alpha = 0.5
		}

		if _trigger == .start || _trigger == .startAndStop {
			postNotif()
		}
	}

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		alpha = 1

		guard let position = getPosition(touches, absolutePosition: false) else {
			return
		}

		if frame.contains(position) {
			if _trigger == .stop || _trigger == .startAndStop {
				postNotif()
			}
		}
	}

	fileprivate func postNotif() {
		guard _trigger != .none else {
			return
		}

		NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: _notifName.name), object: _object.object)
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
