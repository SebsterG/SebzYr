//
//  WindDirection.swift
//  SebzSingleViewYr
//
//  Created by Sebastian Gjertsen on 19.09.2017.
//  Copyright © 2017 Sebastian Gjertsen. All rights reserved.
//

import Foundation
import UIKit

enum WindDirection: Int {
    case N, NNE, NE, ENE, E, ESE ,SE ,SSE, S, SSW, SW, WSW, W, WNW, NW, NNW
    
    init?(degrees: Double) {
        let i = ((degrees + 11.25)/22.5)
        let index = Int(i.truncatingRemainder(dividingBy: 16.0))
        
        guard let windDirection = WindDirection(rawValue: index) else {
            return nil
        }
        
        self = windDirection
    }
    
    var stringValue: String {
        let values = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE",
                      "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        
        return values[rawValue]
    }
    
    var arrowImage: UIImage {
        let image = UIImage(named: "windArrow")!
        
        // Rotate Image by degrees
        
        return image
    }
    
    
    var degrees: Double {
        
        return 0.0
    }
}
