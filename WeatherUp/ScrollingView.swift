//
//  ScrollingView.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 26.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class ScrollingView: UIView {
    
    var delegate: WeatherVC!
    
    private var tappable = true
    
    private var fullDrag: CGFloat!
    private var dragStart: CGFloat!
    private var horizontalPostion: CGFloat!
    private var offset: CGFloat!
    
    private var left: CGFloat {
        return UIScreen.mainScreen().bounds.width - bounds.width / 2
    }
    
    private var right: CGFloat {
        return bounds.width / 2
    }
    
    private var damping: CGFloat {
        return (left + right) * 0.2
    }
    
    private enum Direction {
        case Left
        case Right
        case None
        
        var opposite: Direction {
            if self == .Left {
                return .Right
            }
            if self == . Right {
                return .Left
            }
            return .None
        }
    }
    
    private func dragPercent(pos: CGFloat) -> (Direction, CGFloat) {
        
        let dragAct = dragStart - pos
        let percent = abs(dragAct / fullDrag)
        
        let dir: Direction
        if dragAct > 0 {
            dir = .Left
        } else if dragAct < 0 {
            dir = .Right
        } else {
            dir = .None
        }
        
        let x = percent <= 1 ? percent : 1
        
        return (dir, x)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let position = getPosition(touches) else {
            return
        }
        
        fullDrag = bounds.width - UIScreen.mainScreen().bounds.width
        horizontalPostion = center.y
        dragStart = position.x
        
        offset = center.x - position.x
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let position = getPosition(touches) else {
            return
        }
        
        let newCenter = position.x + offset
        
        guard newCenter >= left - damping && newCenter <= right + damping else {
            return
        }
        
        center = CGPointMake(newCenter, horizontalPostion)
        
        guard newCenter >= left && newCenter <= right else {
            return
        }
        
        let (dir, percent) = dragPercent(position.x)
        
        switch dir {
        case .Left:
            delegate.weatherSV.alpha = 1 - percent
            delegate.rightArrow.alpha = 1 - percent
            delegate.infoSV.alpha = percent
            delegate.leftArrow.alpha = percent
        case .Right:
            delegate.weatherSV.alpha = percent
            delegate.rightArrow.alpha = percent
            delegate.infoSV.alpha = 1 - percent
            delegate.leftArrow.alpha = 1 - percent
        case .None:
            return
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let position = getPosition(touches) else {
            return
        }
        
        let dragPos = position.x + offset
        
        let (dir, percent) = dragPercent(position.x)
        
        let direction: Direction
        
        if dragPos < left || dragPos > right {
            direction = dir
        } else {
            direction = percent >= 0.25 ? dir : dir.opposite
        }
        
        let newCenter: CGFloat
        let alphaWeather: CGFloat
        let alphaInfo: CGFloat
        
        switch direction {
        case .Left:
            newCenter = left
            alphaWeather = 0
            alphaInfo = 1
        case .Right:
            newCenter = right
            alphaWeather = 1
            alphaInfo = 0
        case .None:
            return
        }
        
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 3, options: .CurveEaseOut, animations: {
            self.center = CGPointMake(newCenter, self.horizontalPostion)
            self.delegate.weatherSV.alpha = alphaWeather
            self.delegate.infoSV.alpha = alphaInfo
            self.delegate.leftArrow.alpha = alphaInfo
            self.delegate.rightArrow.alpha = alphaWeather
        }) {_ in}
        
    }
    
    private func getPosition(input: Set<UITouch>) -> CGPoint? {
        guard let touch = input.first else {
            return nil
        }
        
        return touch.locationInView(super.superview)
        
    }

}
