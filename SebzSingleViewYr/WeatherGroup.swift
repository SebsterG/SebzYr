//
//  WeatherGroup.swift
//  SebzSingleViewYr
//
//  Created by Sebastian Gjertsen on 19.09.2017.
//  Copyright © 2017 Sebastian Gjertsen. All rights reserved.
//

import Foundation

struct WeatherGroup{
    var sectionNameDate: String
    var sectionGroup: [WeatherItem]
}

extension WeatherGroup {
    
    static func groupByDate(weatherItems: [WeatherItem]) -> [WeatherGroup] {
        
        var weatherGroups = [WeatherGroup]()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd") // set template after setting locale
        
        var dateNow = ""
        var dateBefore = ""
        
        var dayWeatherArray = [WeatherItem]()
        
        for i in 0...weatherItems.count - 2 {
            
            guard let item2 = weatherItems[i+1] as? WeatherItem else {return []}
            guard let item1 = weatherItems[i] as? WeatherItem else {return []}
            
            dateNow = dateFormatter.string(from: item2.timestamp)
            dateBefore = dateFormatter.string(from: item1.timestamp)
            
            
            if dateNow == dateBefore{
                dayWeatherArray.append(item1)
                
            }else{
                dayWeatherArray.append(item1)
                weatherGroups.append(WeatherGroup(sectionNameDate:dateBefore, sectionGroup: dayWeatherArray))
                dayWeatherArray.removeAll()
                
            }
            
            
        }
        
        return weatherGroups
    }
}
    
