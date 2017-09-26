//
//  ViewController.swift
//  SebzSingleViewYr
//
//  Created by Sebastian Gjertsen on 06.09.2017.
//  Copyright © 2017 Sebastian Gjertsen. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UITableViewController {
    
    var weatherGroups = [WeatherGroup]()
    var weatherCity = [WeatherItem]()
    
    
    
    var timeStamp: String!
    let locationManager = CLLocationManager()
    
    var position: Position!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.locationManager.requestAlwaysAuthorization()
        print("viewDidload")
        configureView()
        /*if CLLocationManager.locationServicesEnabled(){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }*/
        
    }
    
    func configureView(){
        print("config")
        guard let position = self.position else {return}
        print("position: \(position)")
        updateUI(from: position)
        
    }
    
    func updateUI(from position: Position){
        
        getWeatherGroups(latitude: position.latitude, longitude: position.longitude) { weatherGroups in
            print("latitude: \(position.latitude), longitude: \(position.longitude)")
            self.weatherGroups = weatherGroups
            
            //self.timeStamp = self.hoursAndMinutes(timeValue: String(describing: timeStamp))
            
            self.locationManager.fetchCountryAndCity(location: CLLocation(latitude: position.latitude, longitude: position.longitude)) { country, city in
                print("test")
                let label = UILabel(frame: CGRect(x: 10, y:6, width: self.view.frame.size.width, height: 15))
                //print("latitude: \(position.latitude), longitude: \(position.longitude)")
                print(city)
                print(country)
                label.text = "\(city)"
                label.textColor = #colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1)
                label.font = label.font.withSize(11)
                self.title = label.text
                
                self.tableView.reloadData()
            }
        }
    }
    
    func getWeatherGroups(latitude: Double, longitude: Double, completion: @escaping (([WeatherGroup]) -> Void)) {
        //self.locationManager.stopUpdatingLocation()
        NetworkJsonManager.shared.fetchWeatherJSON(latitude: latitude ,longitude: longitude, completionHandler: { (weatherJson, error) in
            
            guard let weatherJson = weatherJson else {
                return
            }
            
            let allItems = WeatherItem.weatherItems(from: weatherJson)
            let groupedItems = WeatherGroup.groupByDate(weatherItems: allItems)
            
            completion(groupedItems)
        })
    }
    
    func degreesToRadians(degrees: Double) -> Double {
        return Double(degrees) * Double.pi / 180
    }


    
    func hoursAndMinutes(timeValue: String) -> String{
        let startIndex = timeValue.index(timeValue.startIndex, offsetBy: 11)
        let endIndex = timeValue.index(timeValue.endIndex, offsetBy: -9)
        let range = startIndex..<endIndex
        return timeValue.substring(with: range)
    }
    
    func dayWeekMonth(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd") // set template after setting locale
        
        return dateFormatter.string(from: date)
    }
    

}


// MARK: - UITableViewDelegate
extension ViewController {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.weatherGroups[section].sectionNameDate
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20))
        returnedView.backgroundColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 0.7202750428)
        
        let label = UILabel(frame: CGRect(x: 10, y:6, width: view.frame.size.width, height: 15))
        label.text = self.weatherGroups[section].sectionNameDate
        label.textColor = #colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1)
        label.font = label.font.withSize(11)
        returnedView.addSubview(label)
        
        return returnedView
    }
}




// MARK: - UITableViewDataSource
extension ViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! CustomTableViewCell
        let weatherItem = self.weatherGroups[indexPath.section].sectionGroup[indexPath.row]
        
        
        cell.tempLabel.text = String(format: "%.1f°", weatherItem.temp - 272.15)
        cell.tempLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        if !weatherItem.hasRain{
            cell.rainLabel.text = String(format: "%.2f mm", (weatherItem.rainVolume)!)
        }else {
            cell.rainLabel.text = "0.00mm"
        }
        
        cell.windSpeedLabel.text = String(format: "%.f m/s", (weatherItem.windSpeed))
        
        //cell.windDirection.text = weatherItem.windDirection?.stringValue
        
        cell.timeLabel.text = hoursAndMinutes(timeValue: String(describing:weatherItem.timestamp))
        
        let windDegreeInradians = degreesToRadians(degrees: -weatherItem.windDegree)
    
        //let tr = CGAffineTransform.identity.rotated(by: CGFloat(-windDegreeInradians))
        let tr = CGAffineTransform(rotationAngle: CGFloat(windDegreeInradians))
        
        cell.windImage.transform = tr
        cell.windImage.image = UIImage(named: "arrow.png")
        
        let weatherIcon = WeatherIcon(iconString: weatherItem.icon)
        cell.iconImage.image = weatherIcon.image
        cell.backgroundColor = #colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1)
        
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.weatherGroups.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherGroups[section].sectionGroup.count
    }
}


// MARK: - CLLocationManagerDelegate
/*
extension ViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            let position = Position(longitude: location.coordinate.longitude,latitude: location.coordinate.latitude)
            
            updateUI(from: position, timeStamp: location.timestamp)
        }
    }
}*/
