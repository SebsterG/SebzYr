//
//  CLLocationManager+fetchCountryAndCity.swift
//  SebzSingleViewYr
//
//  Created by Sebastian Gjertsen on 19.09.2017.
//  Copyright © 2017 Sebastian Gjertsen. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationManager {
    
    func fetchCountryAndCity(location: CLLocation, completion: @escaping (String, String) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            
            if let error = error {
                print(error)
            } else if let country = placemarks?.first?.country,
                let city = placemarks?.first?.locality {
                completion(country, city)
            } else {
                fatalError("Noe gikk galt her")
            }
        }
    }
}
