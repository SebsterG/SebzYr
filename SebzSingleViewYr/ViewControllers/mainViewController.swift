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
import MapKit

struct City{
    var name: String
    var position: Position
    var weatherItem: WeatherItem
    var pollutionItem: PollutionItem
}

class mainViewController: UITableViewController, CLLocationManagerDelegate{
    
    var pollutionValue: Double!
    
    let locationManager = CLLocationManager()
    var weatherCities = [City]()
    
    let searchController = UISearchController(searchResultsController: nil)

    var filteredCities = [City]()
    
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
        configureSearchController()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
            
        }
        let latt = locationManager.location?.coordinate.latitude
        let longt = locationManager.location?.coordinate.longitude
        var thisPollutionItem1: PollutionItem!
        
        getPollution(latitude: Double(String(format: "%.f", latt!))!,longitude: Double(String(format: "%.f",longt!))!, type: "Pollution") { (PollutionItem) in
            
            thisPollutionItem1 = PollutionItem
        
            self.getWeatherCity(latitude: latt!, longitude: longt!, type: "") { (WeatherItem) in
                self.locationManager.fetchCountryAndCity(location: CLLocation(latitude: latt!, longitude: longt!) ) { country, city in
                    self.weatherCities.insert(City(name: city, position: Position(longitude: longt!, latitude: latt!), weatherItem: WeatherItem, pollutionItem: thisPollutionItem1), at: 0)
                    self.locationManager.stopUpdatingLocation()
                    self.tableView.reloadData()
                }
            }
        }
        
        for city in cities{
            let position = city.position
            let cityName = city.name
            var thisPollutionItem2: PollutionItem!
            getPollution(latitude: position.latitude, longitude: position.longitude, type: "Pollution") { (PollutionItem) in
                thisPollutionItem2 = PollutionItem
            
                self.getWeatherCity(latitude: position.latitude, longitude: position.longitude, type: "Pollution"){ (WeatherItem) in
                    self.weatherCities.append(City(name: cityName, position: Position(longitude: position.longitude , latitude: position.latitude), weatherItem: WeatherItem, pollutionItem: thisPollutionItem2))
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}


// MARK: - UITableViewDataSource
extension mainViewController{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CustomCityTableViewCell
       
        var index = 100
        if indexPath.section == 0{
            index = 0
        }else{
            index = indexPath.row + 1
        }
        
        let weatherItem: WeatherItem
        let pollutionItem: PollutionItem
        if isFiltering() {
            weatherItem = filteredCities[indexPath.row].weatherItem
            pollutionItem = filteredCities[indexPath.row].pollutionItem
        } else {
            weatherItem = weatherCities[index].weatherItem
            pollutionItem = weatherCities[index].pollutionItem
        }
        
        if !weatherItem.hasRain{
            cell.rainLabel.text = String(format: "%.2f mm", (weatherItem.rainVolume)!)}
        else {
            cell.rainLabel.text = "0.00 mm"
        }
        cell.tempLabel.text = String(format: "%.1f°", (weatherItem.temp) - 272.15)
        cell.windLabel.text = String(format: "%.f m/s", (weatherItem.windSpeed))
        if isFiltering(){
            cell.cityLabel.text = filteredCities[indexPath.row].name
        }else{
            cell.cityLabel.text = weatherCities[index].name
        }
        let weatherIcon = WeatherIcon(iconString: weatherItem.icon)
        cell.iconImageView.image = weatherIcon.image
        cell.backgroundColor = UIColor(red: 0.0, green: 185.0, blue: 241.0, alpha: 1.0)
        self.title = "Sebz-Vær"
        
        if isFiltering(){
            cell.positionIcon.image = nil
        }else{
            if indexPath.section == 0 {
                cell.positionIcon.image = UIImage(named: "positionIcon")
            }else{
                cell.positionIcon.image = nil
            }
        }
        cell.COValueLabel.text = String(format: "CO: %.1e", pollutionItem.value)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering(){
            return filteredCities.count}
        else{
            if section == 0{
                return weatherCities.count - cities.count
                
            }else {
                return weatherCities.count - 1}
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering(){
            return 1
        }else{
            return 2}
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 130.0
        }else{
            return 110
        }
    }
    
    /*override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1{
            return "Cities"
        }else if section == 0{
            return "Current Position"
        }else {
            return ""
        }
    }*/
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        let label = UILabel()
        if !isFiltering(){
            if section == 0{
                label.text = "Current Position"
            }else{
                label.text = "Cities"
            }
        }else {
            label.text = "Matched Cities"
        }
        label.textColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        label.font = UIFont(name: "Helvetica Neue", size: 18)
        label.frame = CGRect(x: 15, y: -5, width: 200, height: 35)
        view.addSubview(label)
        return view
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailWeather"{
            if let indexPath = tableView.indexPathForSelectedRow{
                guard let detailController = segue.destination as? ViewController else{
                    return
                }
                if isFiltering(){
                    let weatherCity = filteredCities[indexPath.row]
                    detailController.position = weatherCity.position
                }else{
                    if indexPath.section == 0 {
                        let weatherCity = weatherCities[indexPath.row]
                        detailController.position = weatherCity.position}
                    else{
                        let weatherCity = weatherCities[indexPath.row + 1]
                        detailController.position = weatherCity.position
                    }
                }
            }
        }
    }
}

// MARK: - getWeatherCity method
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

extension mainViewController{
    func getPollution(latitude: Double, longitude: Double, type: String, completion: @escaping ((PollutionItem) -> Void)) {
        
        NetworkJsonManager.shared.fetchWeatherJSON(latitude: latitude ,longitude: longitude, type: type, completionHandler: { (weatherJson, error) in
            
            guard let weatherJson = weatherJson else {
                return
            }
           
            let allPollutionItems = PollutionItem.pollutionItems(from: weatherJson)
            
            completion(allPollutionItems[0])
        })
    }
}

// MARK: - Search methods
extension mainViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func configureSearchController(){
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.placeholder = "Search for a city here..."
        UISearchBar.appearance().barTintColor = UIColor(red: 0.0, green: 185.0, blue: 241.0, alpha: 1.0)
        UISearchBar.appearance().tintColor = .black
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
    }
    
    // MARK: - Search
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCities = weatherCities.filter({( city : City) -> Bool in
            return city.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}







