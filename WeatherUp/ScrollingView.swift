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
    
    fileprivate var _tappable = false
    
    fileprivate var _positionInView: CGPoint!
    
    fileprivate var _fullDrag: CGFloat!
    fileprivate var _dragStart: CGFloat!
    fileprivate var _horizontalPosition: CGFloat!
    fileprivate var _offset: CGFloat!
    
    fileprivate var _left: CGFloat {
        return UIScreen.main.bounds.width - bounds.width / 2
    }
    
    fileprivate var _right: CGFloat {
        return bounds.width / 2
    }
    
    fileprivate var _damping: CGFloat {
        return ((_left + _right) / 2) * 0.25
    }
    
    fileprivate enum Direction {
        case left
        case right
        case none
        
        var opposite: Direction {
            if self == .left {
                return .right
            }
            if self == . right {
                return .left
            }
            return .none
        }
    }
    
    func activate() {
        _tappable = true
    }
    
    fileprivate func deactivate() {
        _tappable = false
    }
    
    func reset() {
        if let horizontalPosition = _horizontalPosition {
            _positionInView = CGPoint(x: _right, y: horizontalPosition)
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
    
    fileprivate func setHorizontalPosition() {
        _horizontalPosition = center.y
    }
    
    fileprivate func dragPercent(_ pos: CGFloat) -> (Direction, CGFloat) {
        
        let dragAct = _dragStart - pos
        let percentFull = abs(dragAct / _fullDrag)
        
        let dir: Direction
        if dragAct > 0 {
            dir = .left
        } else if dragAct < 0 {
            dir = .right
        } else {
            dir = .none
        }
        
        let percent = percentFull <= 1 ? percentFull : 1
        
        return (dir, percent)
    }
    
    fileprivate func arrowPercent(point pos: CGFloat) -> CGFloat {
        let distance = _right - _left
        return (pos - _left) / distance
    }
    
    fileprivate func arrowPercent(position pos: CGFloat) -> CGFloat {
        return arrowPercent(point: pos + _offset)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard _tappable, let position = getPosition(touches) else {
            return
        }
        
        _fullDrag = bounds.width - UIScreen.main.bounds.width
        setHorizontalPosition()
        _dragStart = position.x
        
        _offset = center.x - position.x

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard _tappable, let position = getPosition(touches) else {
            return
        }
        
        let newCenter = position.x + _offset
        
        guard newCenter >= _left - _damping && newCenter <= _right + _damping else {
            return
        }
        
        center = CGPoint(x: newCenter, y: _horizontalPosition)
        
        guard newCenter >= _left && newCenter <= _right else {
            return
        }
        
        let (dir, percent) = dragPercent(position.x)
        let arrow = arrowPercent(position: position.x)
        
        let leftAlpha: CGFloat
        let rightAlpha: CGFloat
        
        switch dir {
        case .left:
            leftAlpha = 1 - percent
            rightAlpha = percent
        case .right:
            leftAlpha = percent
            rightAlpha = 1 - percent
        case .none:
            return
        }

        delegate.scrollingView(leftAlpha: leftAlpha, MoveWithRightAlpha: rightAlpha, arrow: arrow)

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
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
        
        if direction == .none {
            let x = center.x
            let off: CGFloat
            switch x {
            case _left:
                off = -15
                direction = .left
            case _right:
                off = 15
                direction = .right
            default:
                return
            }
            
            let centerPoint = CGPoint(x: x - off, y: _horizontalPosition)
            
            delay = 0.1
            
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                self.center = centerPoint
                }, completion: { _ in })
        }
        
        switch direction {
        case .left:
            newCenter = _left
            leftAlpha = 0
            rightAlpha = 1
        case .right:
            newCenter = _right
            leftAlpha = 1
            rightAlpha = 0
        case .none:
            _positionInView = center
            return
        }
        
        let arrow = arrowPercent(point: newCenter)
        let centerPoint = CGPoint(x: newCenter, y: _horizontalPosition)
        
        _positionInView = centerPoint
        
        UIView.animate(withDuration: 0.3, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 3, options: .curveEaseOut, animations: {
            self.center = centerPoint
            self.delegate.scrollingView(leftAlpha: leftAlpha, MoveWithRightAlpha: rightAlpha, arrow: arrow)
            print(arrow)
        }) { _ in }
        
    }
    
    fileprivate func getPosition(_ input: Set<UITouch>) -> CGPoint? {
        guard let touch = input.first else {
            return nil
        }
        
        return touch.location(in: super.superview)
        
    }

}
