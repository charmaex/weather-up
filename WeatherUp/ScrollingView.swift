//
//  ScrollingView.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 26.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class ScrollingView: UIView {
    
    private var maxDrag: CGFloat!
    private var horizontalPostion: CGFloat!
    private var offset: CGFloat!

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let position = getPosition(touches) else {
            return
        }
        
        maxDrag = UIScreen.mainScreen().bounds.width
        horizontalPostion = center.y
        
        offset = center.x - position.x
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let position = getPosition(touches) else {
            return
        }
        
        print(center)
        
        center = CGPointMake(position.x + offset, horizontalPostion)
        
    }
    
    //    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    //
    //    }
    
    private func getPosition(input: Set<UITouch>) -> CGPoint? {
        guard let touch = input.first else {
            return nil
        }
        
        return touch.locationInView(super.superview)
        
    }

}
