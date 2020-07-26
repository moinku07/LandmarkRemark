//
//  MockLocationManager.swift
//  LandmarkRemarkTests
//
//  Created by Moin Uddin on 24/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import Foundation
import CoreLocation
@testable import LandmarkRemark

class MockLocationManager: LocationManager{
    
    private (set) var started: Bool = false
    
    var locationManagerAvailable: Bool = false
    var permissionDenied: Bool = false
    
    var error: Error?
    
    var currentLocation: CLLocation?{
        if self.locationManagerAvailable && !self.permissionDenied && self.started{
            return CLLocation(latitude: -31.959299, longitude: 115.858496)
        }
        return nil
    }
    
    static let notAuthorisedError = NSError(domain: kCLErrorDomain, code: Int(CLAuthorizationStatus.denied.rawValue), userInfo: nil)
    static let noLocationError = NSError(domain: kCLErrorDomain, code: 0, userInfo: nil)
    
    func requestAuthorisation() {
        
    }
    
    func start(completion: @escaping (CLLocation?, Error?) -> Void) {
        self.started = true
        
        DispatchQueue.global(qos: .default).async {
            completion(self.currentLocation, self.error)
        }
    }
    
    func stop(){
        self.started = false
    }
}
