//
//  LocationManager.swift
//  LandmarkRemark
//
//  Created by Moin Uddin on 24/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import Foundation
import CoreLocation

// Blueprint for the LocationManger
protocol LocationManager{
    var locationManagerAvailable: Bool {get} // return whether the location manager is available or not. defaults to false
    var permissionDenied: Bool {get} // returns the status of permission denial. defaults to false
    var currentLocation: CLLocation? {get} // returns the last known current device location. defaults to nil
    
    func start(completion: @escaping (CLLocation?, Error?)->Void) // start the location manager to monitor location updates
    func stop() // stop the location updates
}
