//
//  ScrollingView.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 26.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

protocol ScrollingViewDelegate: NSObjectProtocol {
    func scrollingView(leftAlpha left: CGFloat, MoveWithRightAlpha right: CGFloat, arrow: CGFloat)
}

class ScrollingView: UIView {
    
    var delegate: ScrollingViewDelegate!
    
    private var _tappable = false
    
    private var _positionInView: CGPoint!
    
    private var _fullDrag: CGFloat!
    private var _dragStart: CGFloat!
    private var _horizontalPosition: CGFloat!
    private var _offset: CGFloat!
    
    private var _left: CGFloat {
        return UIScreen.mainScreen().bounds.width - bounds.width / 2
    }
    
    private var _right: CGFloat {
        return bounds.width / 2
    }
    
    private var _damping: CGFloat {
        return ((_left + _right) / 2) * 0.25
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
    
    func activate() {
        _tappable = true
    }
    
    private func deactivate() {
        _tappable = false
    }
    
    func reset() {
        if let horizontalPosition = _horizontalPosition {
            _positionInView = CGPointMake(_right, horizontalPosition)
        }
        
        delegate.scrollingView(leftAlpha: 1, MoveWithRightAlpha: 0, arrow: 1)
        positionView()
        deactivate()
    }
    
    func positionView() {
        if _positionInView != nil {
            center = _positionInView
        }
    }
    
    private func setHorizontalPosition() {
        _horizontalPosition = center.y
    }
    
    private func dragPercent(pos: CGFloat) -> (Direction, CGFloat) {
        
        let dragAct = _dragStart - pos
        let percentFull = abs(dragAct / _fullDrag)
        
        let dir: Direction
        if dragAct > 0 {
            dir = .Left
        } else if dragAct < 0 {
            dir = .Right
        } else {
            dir = .None
        }
        
        let percent = percentFull <= 1 ? percentFull : 1
        
        return (dir, percent)
    }
    
    private func arrowPercent(point pos: CGFloat) -> CGFloat {
        let distance = _right - _left
        return (pos - _left) / distance
    }
    
    private func arrowPercent(position pos: CGFloat) -> CGFloat {
        return arrowPercent(point: pos + _offset)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard _tappable, let position = getPosition(touches) else {
            return
        }
        
        _fullDrag = bounds.width - UIScreen.mainScreen().bounds.width
        setHorizontalPosition()
        _dragStart = position.x
        
        _offset = center.x - position.x

    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard _tappable, let position = getPosition(touches) else {
            return
        }
        
        let newCenter = position.x + _offset
        
        guard newCenter >= _left - _damping && newCenter <= _right + _damping else {
            return
        }
        
        center = CGPointMake(newCenter, _horizontalPosition)
        
        guard newCenter >= _left && newCenter <= _right else {
            return
        }
        
        let (dir, percent) = dragPercent(position.x)
        let arrow = arrowPercent(position: position.x)
        
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

        delegate.scrollingView(leftAlpha: leftAlpha, MoveWithRightAlpha: rightAlpha, arrow: arrow)

    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard _tappable, let position = getPosition(touches) else {
            return
        }
        
        let dragPos = position.x + _offset
        
        let (dir, percent) = dragPercent(position.x)
        
        var direction: Direction
        
        if dragPos < _left || dragPos > _right {
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
            case _left:
                off = -15
                direction = .Left
            case _right:
                off = 15
                direction = .Right
            default:
                return
            }
            
            let centerPoint = CGPointMake(x - off, _horizontalPosition)
            
            delay = 0.1
            
            UIView.animateWithDuration(0.1, delay: 0, options: .CurveEaseIn, animations: {
                self.center = centerPoint
                }, completion: { _ in })
        }
        
        switch direction {
        case .Left:
            newCenter = _left
            leftAlpha = 0
            rightAlpha = 1
        case .Right:
            newCenter = _right
            leftAlpha = 1
            rightAlpha = 0
        case .None:
            _positionInView = center
            return
        }
        
        let arrow = arrowPercent(point: newCenter)
        let centerPoint = CGPointMake(newCenter, _horizontalPosition)
        
        _positionInView = centerPoint
        
        UIView.animateWithDuration(0.3, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 3, options: .CurveEaseOut, animations: {
            self.center = centerPoint
            self.delegate.scrollingView(leftAlpha: leftAlpha, MoveWithRightAlpha: rightAlpha, arrow: arrow)
            print(arrow)
        }) { _ in }
        
    }
    
    private func getPosition(input: Set<UITouch>) -> CGPoint? {
        guard let touch = input.first else {
            return nil
        }
        
        return touch.locationInView(super.superview)
        
    }

}
