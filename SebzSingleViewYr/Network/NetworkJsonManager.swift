//
//  NetworkJsonManager.swift
//  SebzSingleViewYr
//
//  Created by Sebastian Gjertsen on 19.09.2017.
//  Copyright © 2017 Sebastian Gjertsen. All rights reserved.
//

import Foundation

class NetworkJsonManager {

    static let shared = NetworkJsonManager()
    
    private let session = URLSession(configuration: .default)
    
    private init() {}
    
    @discardableResult
    func fetchWeatherJSON (latitude: Double = 0.0, longitude: Double = 0.0, type: String = "", completionHandler completion: @escaping ([String: Any]?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        let apiKey: String = "034b102c87bd7d279a8075e1ac71a52c"
        var url: URL!
        if type == ""{
            url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&APPID=\(apiKey)")}
        else{
            url = URL(string: "https://api.openweathermap.org/pollution/v1/co/\(Int(latitude)),\(Int(longitude))/current.json?appid=\(apiKey)")
            //url = URL(string: "https://api.openweathermap.org/pollution/v1/co/60,10/current.json?appid=034b102c87bd7d279a8075e1ac71a52c")
        }
        let task = session.dataTask(with: url!){ ( data, response, error) in
            if error != nil{
                print("Something went wrong")
                print(error!)
                DispatchQueue.main.async {
                    completion([:], error as NSError?)
                }
            }else{
                if let content = data{
                    do{
                        let weatherJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                        
                        //print(String.init(data: content, encoding: .utf8)!)
                        DispatchQueue.main.async {
                            completion(weatherJson, nil)
                        }
                        
                    }catch{
                    }
                }
            }
            
        }
        task.resume()
        return task
    }
}
