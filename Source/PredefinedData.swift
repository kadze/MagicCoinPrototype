//
//  PredefinedData.swift
//  MagicCoin
//
//  Created by ASH on 8/12/17.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import Foundation
import CoreLocation

enum PredefinedData {
    static let terminals: [Terminal] = [
        Terminal(id: 23133, name: "Thaniya Plaza", location: CLLocation(latitude: 50.448418, longitude: 30.523225), address: "Kiev, 13 Khreshatik str.", timetable: "Mon-Fri: 8.00am – 9.00pm Sat-Sun: Closed"),
        Terminal(id: 41455, name: "Mega Plaza Wangburapa", location: CLLocation(latitude: 50.451967, longitude: 30.526036), address: "Kiev, 7 Khreshatik str.", timetable: "Mon-Fri: 8.00am – 9.00pm Sat-Sun: Closed"),
        Terminal(id: 35744, name: "The Old Siam Plaza", location: CLLocation(latitude: 50.453201, longitude: 30.518468), address: "Kiev, 17 Volodymyr str", timetable: "Mon-Fri: 8.00am – 9.00pm Sat-Sun: Closed"),
        Terminal(id: 12499, name: "Tha Maharaj", location: CLLocation(latitude: 50.442164, longitude: 30.521533), address: "Kiev, 2 Bessarabs'ka Square", timetable: "Mon-Fri: 8.00am – 9.00pm Sat-Sun: Closed"),
        Terminal(id: 77665, name: "Saffon", location: CLLocation(latitude: 50.449246, longitude: 30.514231), address: "Kiev, 4 Volodymyr str.", timetable: "Mon-Fri: 8.00am – 9.00pm Sat-Sun: Closed")
    ]
}
