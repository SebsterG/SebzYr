//
//  Weatherjson.swift
//  SebzSingleViewYr
//
//  Created by Sebastian Gjertsen on 19.09.2017.
//  Copyright © 2017 Sebastian Gjertsen. All rights reserved.
//

import Foundation

struct WeatherItem {
    
    let temp: Double
    let icon: String
    let windSpeed: Double
    let windDegree: Double
    let rawTimestamp: Int
    let rainVolume: Double?
    var dateFomatter = DateFormatter()
    
    var timestamp: Date {
        return Date(timeIntervalSince1970: Double(rawTimestamp))
    }
    
    var hasRain: Bool {
        return rainVolume == nil
    }
    
    var windDirection: WindDirection? {
        return WindDirection(degrees: windDegree)
    }
    
    var weatherIcon: WeatherIcon? {
        
        return WeatherIcon(iconString: icon)
    }
}

extension WeatherItem {

    init?(from json: Any) {
        
        guard let json = json as? [String: Any] else {
            return nil
        }
       
    
        guard let main = json["main"] as? [String: Any], let temp = main["temp"] as? Double else {
            return nil
        }
        
        guard let weatherjsonsArray = json["weather"] as? [[String: Any]], let icon = weatherjsonsArray.first?["icon"] as? String else {
            return nil
        }
        
        guard let windArray = json["wind"] as? [String: Any], let windSpeed = windArray["speed"] as? Double, let windDegree = windArray["deg"] as? Double else {
            return nil
        }
        
        guard let rawTimestamp = json["dt"] as? Int else {
            return nil
        }
        
        var rainVolume: Double? {
            
            guard let rain = json["rain"] as? [String: Any], let rainVolume = rain["3h"] as? Double else {
                return nil
            }
            
            return rainVolume
        }
        
        self.temp = temp
        self.icon = icon
        self.windSpeed = windSpeed
        self.windDegree = windDegree
        self.rawTimestamp = rawTimestamp
        self.rainVolume = rainVolume
    }
}


extension WeatherItem {
    
    static func weatherItems(from json: [String: Any]) -> [WeatherItem] {
        
        guard let weatherList = json["list"] as? [[String: Any]] else {
            return []
        }
        
        var weatherItems: [WeatherItem] = []
        for item in weatherList {
            if let weatherItem = WeatherItem(from: item) {
                weatherItems.append(weatherItem)
            } else {
                return []
            }
        }
        
        return weatherItems
    }
}
