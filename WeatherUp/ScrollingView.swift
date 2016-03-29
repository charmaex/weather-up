//
//  ScrollingView.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 26.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

protocol ScrollingViewDelegate: NSObjectProtocol {
    func scrollingView(leftAlpha left: CGFloat, MoveWithRightAlpha right: CGFloat)
}

class ScrollingView: UIView {
    
    var delegate: ScrollingViewDelegate!
    
    private var tappable = true
    
    private var positionInView: CGPoint!
    
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
        return ((left + right) / 2) * 0.25
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
    
    func positionView() {
        if positionInView != nil {
            center = positionInView
        }
    }
    
    private func dragPercent(pos: CGFloat) -> (Direction, CGFloat, CGFloat) {
        
        let dragAct = dragStart - pos
        let percentFull = abs(dragAct / fullDrag)
        
        let dir: Direction
        if dragAct > 0 {
            dir = .Left
        } else if dragAct < 0 {
            dir = .Right
        } else {
            dir = .None
        }
        
        let percent = percentFull <= 1 ? percentFull : 1
        
        return (dir, percent, percentFull) // percentFull needed in Version 1.1
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
        
        let (dir, percent, _) = dragPercent(position.x)
        
        let leftAlpha: CGFloat
        let rightAlpha: CGFloat
        
        switch dir {
        case .Left:
            leftAlpha = 1 - percent
            rightAlpha = percent
        case .Right:
            leftAlpha = percent
            rightAlpha = 1 - percent
        case .None:
            return
        }

        delegate.scrollingView(leftAlpha: leftAlpha, MoveWithRightAlpha: rightAlpha)

    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let position = getPosition(touches) else {
            return
        }
        
        let dragPos = position.x + offset
        
        let (dir, percent, _) = dragPercent(position.x)
        
        var direction: Direction
        
        if dragPos < left || dragPos > right {
            direction = dir
        } else {
            direction = percent >= 0.2 ? dir : dir.opposite
        }
        
        let newCenter: CGFloat
        let leftAlpha: CGFloat
        let rightAlpha: CGFloat
        
        var delay = 0.0
        
        if direction == .None {
            let x = center.x
            let off: CGFloat
            switch x {
            case left:
                off = -15
                direction = .Left
            case right:
                off = 15
                direction = .Right
            default:
                return
            }
            
            let centerPoint = CGPointMake(x - off, horizontalPostion)
            
            delay = 0.1
            
            UIView.animateWithDuration(0.1, delay: 0, options: .CurveEaseIn, animations: {
                self.center = centerPoint
                }, completion: { _ in })
        }
        
        switch direction {
        case .Left:
            newCenter = left
            leftAlpha = 0
            rightAlpha = 1
        case .Right:
            newCenter = right
            leftAlpha = 1
            rightAlpha = 0
        case .None:
            return
        }
        
        let centerPoint = CGPointMake(newCenter, horizontalPostion)
        
        positionInView = centerPoint
        
        UIView.animateWithDuration(0.3, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 3, options: .CurveEaseOut, animations: {
            self.center = centerPoint
            self.delegate.scrollingView(leftAlpha: leftAlpha, MoveWithRightAlpha: rightAlpha)
        }) { _ in }
        
    }
    
    private func getPosition(input: Set<UITouch>) -> CGPoint? {
        guard let touch = input.first else {
            return nil
        }
        
        return touch.locationInView(super.superview)
        
    }

}
