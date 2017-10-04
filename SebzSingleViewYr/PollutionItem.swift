//
//  PollutionItem.swift
//  SebzSingleViewYr
//
//  Created by Sebastian Gjertsen on 02.10.2017.
//  Copyright © 2017 Sebastian Gjertsen. All rights reserved.
//

import Foundation

struct PollutionItem{
    let value: Double
    let pressure: Double
}

extension PollutionItem{
    
    init?(from json: Any){
        guard let json = json as? [String: Any] else{
            return nil
        }
        
        //guard let data = json["data"] as? [String: Any] else{
        //    return nil
        //}
        
        guard let pressure = json["pressure"] as? Double else {
            return nil
        }
        guard let CoValue = json["value"] as? Double else {
            return nil
        }
        self.value = CoValue
        self.pressure = pressure
    }
}
extension PollutionItem {
    
    static func pollutionItems(from json: [String: Any]) -> [PollutionItem] {
        
        guard let pollutionList = json["data"] as? [[String: Any]] else {
            print("inside pollutionList")
            return []
        }
        
        var pollutionItems: [PollutionItem] = []
        for item in pollutionList {
            if let pollutionItem = PollutionItem(from: item) {
                pollutionItems.append(pollutionItem)
            } else {
                return []
            }
        }
        
        return pollutionItems
    }
}
