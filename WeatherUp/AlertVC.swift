//
//  AlertVC.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 27.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class AlertVC: UIAlertController {
    
    override var preferredStyle: UIAlertControllerStyle {
        return .Alert
    }

    func configureLocationAlert() {
        
        title = "Location Services Disabled"
        message = "Please enable location services for this app in Settings."
        
        let settingsAction = UIAlertAction(title: "Settings", style: .Cancel) { (UIAlertAction) in
            
            let url = NSURL(string: "prefs:root=LOCATION_SERVICES")!
            UIApplication.sharedApplication().openURL(url)
        }
        
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        addAction(settingsAction)
        addAction(okAction)
        
        preferredAction = settingsAction
    }

}
