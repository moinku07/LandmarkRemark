//
//  CLLocationManager+Extensions.swift
//  LandmarkRemark
//
//  Created by Moin Uddin on 24/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import UIKit
import CoreLocation

class LRLocationManager: NSObject, LocationManager{
    var locationManager: CLLocationManager!
    
    var locationManagerAvailable: Bool{
        return CLLocationManager.locationServicesEnabled()
            && (CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways)
            && CLLocationManager.authorizationStatus() != .notDetermined
            && CLLocationManager.authorizationStatus() != .restricted
            && CLLocationManager.authorizationStatus() != .denied
    }
    
    var permissionDenied: Bool {
        return CLLocationManager.authorizationStatus() == .denied
    }
    
    var currentLocation: CLLocation?{
        return self.locationManager.location
    }
    
    var completion: ((CLLocation?, Error?) -> Void)?
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
    }
    
    func start(completion: @escaping (CLLocation?, Error?) -> Void){
        self.completion = completion
        
        self.locationManager.startUpdatingLocation()
    }
    
    func stop(){
        self.locationManager.stopUpdatingLocation()
    }
}

extension LRLocationManager: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if [CLAuthorizationStatus.authorizedAlways, CLAuthorizationStatus.authorizedWhenInUse].contains(status){
            self.locationManager.startUpdatingLocation()
        }else if [CLAuthorizationStatus.restricted, CLAuthorizationStatus.denied].contains(status){
            self.stop()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            self.completion?(location, nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        self.completion?(nil, error)
    }
}
