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
    
    //var position: Position?
    var rainVolume: Double = 0.0
    var temp: Double = 0.0
    var windSpeed: Double = 0.0
    var city: String = ""
    var icon: String = ""
    
    var bergenPosition: Position?
    var bergenRainVolume: Double = 0.0
    var bergenTemp: Double = 0.0
    var bergenWindSpeed: Double = 0.0
    var bergenCity: String = ""
    var bergenIcon: String = ""
    
    let locationManager = CLLocationManager()
    
    var weatherCities = [City]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
            //self.tableView.reloadData()
            //self.locationManager.stopUpdatingLocation()
        }
        let latt = locationManager.location?.coordinate.latitude
        let longt = locationManager.location?.coordinate.longitude
        print("latitude:", latt!)
        
        getWeatherCity(latitude: latt!, longitude: longt!, type: "") { (WeatherItem) in
            
            self.locationManager.fetchCountryAndCity(location: CLLocation(latitude: latt!, longitude: longt!) ) { country, city in
                self.weatherCities.append(City(name: city, position: Position(longitude: longt!, latitude: latt!), weatherItem: WeatherItem))
                self.tableView.reloadData()
            }
            
        }
        
        getWeatherCity(latitude: 60.39, longitude: 5.32, type: ""){(WeatherItem) in
            
            self.locationManager.fetchCountryAndCity(location: CLLocation(latitude: 60.39, longitude: 5.32)) { country, city in
                self.weatherCities.append(City(name: city, position: Position(longitude: 5.32 , latitude: 60.39), weatherItem: WeatherItem))
                self.tableView.reloadData()
            }
        }
        print(weatherCities)
        
        self.tableView.reloadData()
        
    }
}

// MARK: - UITableViewDataSource
extension mainViewController{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CustomCityTableViewCell
        
        let weatherItem = weatherCities[indexPath.row].weatherItem
        print((weatherItem.temp))
        
        
        if !weatherItem.hasRain{
            cell.rainLabel.text = String(format: "%.2f mm", (weatherItem.rainVolume)!)}
        else {
            cell.rainLabel.text = "0.00 mm"
        }
        cell.tempLabel.text = String(format: "%.1f°", (weatherItem.temp) - 272.15)
        cell.windLabel.text = String(format: "%.f m/s", (weatherItem.windSpeed))
        cell.cityLabel.text = weatherCities[indexPath.row].name
        
        let weatherIcon = WeatherIcon(iconString: weatherItem.icon)
        cell.iconImageView.image = weatherIcon.image
        cell.backgroundColor = #colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1)
        self.title = "Sebz-Vær"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherCities.count
        
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailWeather"{
            if let indexPath = tableView.indexPathForSelectedRow{
                let weatherCity  = weatherCities[indexPath.row]
                guard let detailController = segue.destination as? ViewController else{
                    return
                }
                print(weatherCity.position)
                print("inne i prepeare for segue")
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
            print("inside get weathercity")
            completion(allItems[0])
            self.tableView.reloadData()
        })
    }
}

/*
extension mainViewController{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            getWeatherCity(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, type: "") { (WeatherItem) in
                
                if !WeatherItem.hasRain{
                    self.rainVolume = WeatherItem.rainVolume!}
                else{
                    self.rainVolume = 0.0
                }
                self.temp = WeatherItem.temp
                self.windSpeed = WeatherItem.windSpeed
                self.icon = WeatherItem.icon
 
                var thisCity = ""
                manager.fetchCountryAndCity(location: location) { country, city in
                    thisCity = city
                }
                
                self.weatherCities.append(City(name: thisCity, position: Position(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude), weatherItem: WeatherItem))
                
                self.tableView.reloadData()
            }
           
        }
    }
}*/


