//
//  LocationViewModel.swift
//  LandmarkRemark
//
//  Created by Moin Uddin on 24/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import Foundation
import CoreLocation

enum LocationViewModelState{
    case notStarted
    case inProgress
    case notAuthorised
}

class LocationViewModel{
    
    var locationManager: LocationManager!
    
    var state: LocationViewModelState = .notStarted
    
    var currentLocation: CLLocation?{
        return self.locationManager.currentLocation
    }
    
    var completion: ((CLLocation?, Error?) -> Void)?
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
    }
    
    func startLocationManager(completion: ((CLLocation?, Error?)->Void)?){
        self.completion = completion
        
        guard self.locationManager.locationManagerAvailable else{
            self.state = .notStarted
            return
        }
        
        guard !self.locationManager.permissionDenied else{
            self.state = .notStarted
            return
        }
        
        self.state = .inProgress
        
        self.locationManager.start{ location, error in
            if let error = error{
                let nsError = error as NSError
                if nsError.domain == kCLErrorDomain && nsError.code == CLAuthorizationStatus.denied.rawValue{
                    self.state = .notAuthorised
                    self.locationManager.stop()
                }
            }
            self.completion?(location, error)
        }
    }
    
    func stopLocationManager(){
        self.state = .notStarted
        self.locationManager.stop()
        self.completion = nil
    }
}
