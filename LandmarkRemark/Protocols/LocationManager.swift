//
//  LocationManager.swift
//  LandmarkRemark
//
//  Created by Moin Uddin on 24/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManager{
    var locationManagerAvailable: Bool {get}
    var permissionDenied: Bool {get}
    var currentLocation: CLLocation? {get}
    
    func start(completion: @escaping (CLLocation?, Error?)->Void)
    func stop()
}
