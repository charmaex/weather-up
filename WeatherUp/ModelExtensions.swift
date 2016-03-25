//
//  ModelExtensions.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 25.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation
import MapKit

extension CLLocationDegrees {
    
    func roundTo(decimals i: Int) -> Double {
        guard i >= 0 else {
            return self
        }
        let inc = pow(10, Double(i))
        
        return round(self * inc) / inc
    }
    
}
