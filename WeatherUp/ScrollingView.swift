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
        
        var opposite: Direction {
            if self == .Left {
                return .Right
            }
            return .Left
        }
    }
    
    private func dragPercent(pos: CGFloat) -> (Direction, CGFloat) {
        
        let dragAct = dragStart - pos
        let percent = abs(dragAct / fullDrag)
        
        let dir: Direction = dragAct > 0 ? .Left : .Right
        let x = percent <= 1 ? percent : 1
        
        print(dir, x, dragAct)
        
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
            delegate.infoSV.alpha = percent
        case .Right:
            delegate.weatherSV.alpha = percent
            delegate.infoSV.alpha = 1 - percent
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let position = getPosition(touches) else {
            return
        }
        
        let dragPos = position.x + offset
        
        let (dir, percent) = dragPercent(position.x)
        
        let direction: Direction
        
        if dragPos > left || dragPos < right {
            direction = dir
        } else {
            direction = percent > 0.4 ? dir : dir.opposite
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
        }
        
        UIView.animateWithDuration(0.3) {
            self.center = CGPointMake(newCenter, self.horizontalPostion)
            self.delegate.weatherSV.alpha = alphaWeather
            self.delegate.infoSV.alpha = alphaInfo
            }
        
    }
    
    private func getPosition(input: Set<UITouch>) -> CGPoint? {
        guard let touch = input.first else {
            return nil
        }
        
        return touch.locationInView(super.superview)
        
    }

}
