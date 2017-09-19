//
//  WeatherIcons.swift
//  SebzSingleViewYr
//
//  Created by Sebastian Gjertsen on 07.09.2017.
//  Copyright © 2017 Sebastian Gjertsen. All rights reserved.
//

import Foundation
import UIKit

import Foundation
import UIKit

enum WeatherIcon {
    case clearDay
    case clearNight
    case rain
    case snow
    case cloudy
    case partlyCloudyDay
    case partlyCloudyNight
    case `default`
    init(iconString: String) {
        switch iconString {
        case "01d": self = .clearDay
        case "01n": self = .clearNight
        case "09n": self = .rain
        case "10n": self = .rain
        case "10d": self = .rain
        case "13d": self = .snow
        case "03d": self = .cloudy
        case "04d": self = .partlyCloudyDay
        case "04n": self = .partlyCloudyNight
        default: self = .default
        }
    }
}

extension WeatherIcon{
    var image: UIImage{
        switch self{
        case .clearDay: return #imageLiteral(resourceName: "clear-day")
        case .clearNight: return #imageLiteral(resourceName: "clear-night")
        case .rain: return #imageLiteral(resourceName: "rain")
        case .snow: return #imageLiteral(resourceName: "snow")
        case .cloudy: return #imageLiteral(resourceName: "cloudy")
        case .partlyCloudyDay: return #imageLiteral(resourceName: "partly-cloudy-day")
        case .partlyCloudyNight: return #imageLiteral(resourceName: "partly-cloudy-night")
        case .default: return #imageLiteral(resourceName: "default")
        }
    }
}
