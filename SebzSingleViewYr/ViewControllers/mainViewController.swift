//
//  mainViewController.swift
//  SebzSingleViewYr
//
//  Created by Sebastian Gjertsen on 20.09.2017.
//  Copyright © 2017 Sebastian Gjertsen. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

struct City{
    var name: String
    var position: Position
    var weatherItem: WeatherItem
}

class mainViewController: UITableViewController, CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    
    var weatherCities = [City]()
    
    let cities = [
        CitiesPosition(name:"Bergen", position: Position(longitude: 5.32, latitude: 60.39)),
        CitiesPosition(name:"Oslo", position: Position(longitude: 10.757933, latitude: 59.911491)),
        CitiesPosition(name:"Trondheim", position: Position(longitude: 10.421906, latitude: 63.446827)),
        CitiesPosition(name:"Tromsø", position: Position(longitude: 18.955324, latitude: 69.649208) ),
        CitiesPosition(name:"Stavanger", position: Position(longitude: 5.733107, latitude: 58.969975 )),
        CitiesPosition(name:"Ålesund", position: Position(longitude: 6.149482, latitude: 62.472229)),
        CitiesPosition(name:"New York", position: Position(longitude: -73.985428, latitude: 40.748817 )),
        CitiesPosition(name:"Los Angeles", position: Position(longitude: -118.243683, latitude: 34.052235))
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
            
        }
        let latt = locationManager.location?.coordinate.latitude
        let longt = locationManager.location?.coordinate.longitude
        
        getWeatherCity(latitude: latt!, longitude: longt!, type: "") { (WeatherItem) in
            self.locationManager.fetchCountryAndCity(location: CLLocation(latitude: latt!, longitude: longt!) ) { country, city in
                self.weatherCities.insert(City(name: city, position: Position(longitude: longt!, latitude: latt!), weatherItem: WeatherItem), at: 0)
                self.locationManager.stopUpdatingLocation()
                self.tableView.reloadData()
            }
        }
        
        for city in cities{
            let position = city.position
            let cityName = city.name
            getWeatherCity(latitude: position.latitude, longitude: position.longitude, type: ""){(WeatherItem) in
                self.weatherCities.append(City(name: cityName, position: Position(longitude: position.longitude , latitude: position.latitude), weatherItem: WeatherItem))
                self.tableView.reloadData()
            }
            
        }
    }
}


// MARK: - UITableViewDataSource
extension mainViewController{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CustomCityTableViewCell
        print("section: ", indexPath.section)
        print("row: ", indexPath.row)
       
        var index = 100
        if indexPath.section == 0{
            index = 0
        }else{
            index = indexPath.row + 1
        }
        let weatherItem = weatherCities[index].weatherItem
        if !weatherItem.hasRain{
            cell.rainLabel.text = String(format: "%.2f mm", (weatherItem.rainVolume)!)}
        else {
            cell.rainLabel.text = "0.00 mm"
        }
        cell.tempLabel.text = String(format: "%.1f°", (weatherItem.temp) - 272.15)
        cell.windLabel.text = String(format: "%.f m/s", (weatherItem.windSpeed))
        cell.cityLabel.text = weatherCities[index].name
        
        let weatherIcon = WeatherIcon(iconString: weatherItem.icon)
        cell.iconImageView.image = weatherIcon.image
        cell.backgroundColor = #colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1)
        self.title = "Sebz-Vær"
        
        if indexPath.section == 0 {
            cell.positionIcon.image = UIImage(named: "positionIcon")
        }else{
            cell.positionIcon.image = nil
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return weatherCities.count - cities.count
        }else{
            return weatherCities.count - 1
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 130.0
        }else{
            return 110
        }

    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1{
            return "Cities"
        }else{
            return ""
        }
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailWeather"{
            if let indexPath = tableView.indexPathForSelectedRow{
                let weatherCity  = weatherCities[indexPath.row + 1]
                guard let detailController = segue.destination as? ViewController else{
                    return
                }
                
                detailController.position = weatherCity.position
            }
            
        }
    }
}

extension mainViewController{
    func getWeatherCity(latitude: Double, longitude: Double, type: String, completion: @escaping ((WeatherItem) -> Void)) {
        
        NetworkJsonManager.shared.fetchWeatherJSON(latitude: latitude ,longitude: longitude, completionHandler: { (weatherJson, error) in
            
            guard let weatherJson = weatherJson else {
                return
            }
            let allItems = WeatherItem.weatherItems(from: weatherJson)
            completion(allItems[0])
        })
    }
}




