//
//  Singleton.swift
//  HoloArts
//
//  Created by Oleh Korchytskyi on 07/07/2017.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import Foundation

protocol Singleton: class {
    static var shared: Self { get }
}
