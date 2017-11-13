//
//  LocationManagerHolder.swift
//  MagicCoin
//
//  Created by ASH on 8/14/17.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManagerHolder {
    static let shared = LocationManagerHolder()
    var locationManager: CLLocationManager
    
    private init () {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
    }
}
