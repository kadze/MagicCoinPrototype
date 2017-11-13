//
//  Terminal.swift
//  MagicCoin
//
//  Created by ASH on 8/12/17.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import Foundation
import CoreLocation

class Terminal {
    let id: Int
    let name: String
    let location: CLLocation!
    let address: String
    let timetable: String
    
    init(id: Int, name: String, location: CLLocation, address: String, timetable: String) {
        self.id = id
        self.name = name
        self.location = location
        self.address = address
        self.timetable = timetable
        
    }
    
    var distance: Int {
        get {
            let locationManager = LocationManagerHolder.shared.locationManager
            if CLLocationManager.locationServicesEnabled() {
                if  let currentLocation = locationManager.location {
                    let distance = self.location.distance(from: currentLocation)
                    return Int(distance)
                }
                
                return 0
            } else {
                return 0
            }
        }
    }
}
