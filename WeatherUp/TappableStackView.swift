//
//  TappableStackView.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 28.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class TappableStackView: UIStackView {
    
    private var _trigger: Trigger = .None
    private var _notifName:  Notification!
    private var _object: Notification.Listener!
    
    enum Trigger {
        case None
        case Start
        case StartAndStop
        case Stop
    }
    
    func configureAction(trigger t: Trigger, action n: Notification, listener o: Notification.Listener) {
        _trigger = t
        _notifName = n
        _object = o
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if _trigger != .None {
            alpha = 0.5
        }
        
        if _trigger == .Start || _trigger == .StartAndStop {
            postNotif()
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        alpha = 1
        
        guard let position = getPosition(touches, absolutePosition: false) else {
            return
        }
        
        if frame.contains(position) {
            if _trigger == .Stop || _trigger == .StartAndStop {
                postNotif()
            }
        }
    }
    
    private func postNotif() {
        guard _trigger != .None else {
            return
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(_notifName.name, object: _object.object)
    }
    
    private func getPosition(input: Set<UITouch>, absolutePosition: Bool) -> CGPoint? {
        guard let touch = input.first else {
            return nil
        }
        
        if absolutePosition {
            return touch.locationInView(super.superview?.superview)
        }
        
        return touch.locationInView(super.superview)
    }
    
}
