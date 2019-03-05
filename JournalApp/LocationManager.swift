//
//  LocationManager.swift
//  JournalApp
//
//  Created by Akshay Verma on 2019-03-05.
//  Copyright © 2019 Akshay Verma. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager{
    static let shared: CLLocationManager = {
        let placeHolder = CLLocationManager()
        placeHolder.desiredAccuracy = kCLLocationAccuracyKilometer
        return placeHolder
    }()
}
