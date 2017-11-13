//
//  UIDevice+Utility.swift
//  HoloArts
//
//  Created by Oleh Korchytskyi on 07/07/2017.
//  Copyright © 2017 Gamayun. All rights reserved.
//

import UIKit

extension UIDevice {
    
    static var currendVendorId: String? {
        return current.identifierForVendor?.uuidString
    }
    
    
}
