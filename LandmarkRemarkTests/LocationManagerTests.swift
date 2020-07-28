//
//  LocationManagerTests.swift
//  LandmarkRemarkTests
//
//  Created by Moin Uddin on 26/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import XCTest
@testable import LandmarkRemark

class when_LocationManager_NotAvailable: LandmarkRemarkTests_Setup{
    func test_DoesNotStart(){
        self.mockLocationManager.locationManagerAvailable = false
        
        self.locationVM.startLocationManager(completion: nil)
        
        XCTAssertEqual(self.locationVM.state, .notStarted)
    }
}

class when_Location_NotAuthorised: LandmarkRemarkTests_Setup{
    func test_DoesNotStart(){
        self.mockLocationManager.permissionDenied = true
        
        self.locationVM.startLocationManager(completion: nil)
        
        XCTAssertEqual(self.locationVM.state, .notStarted)
    }
}

class when_Location_Authorised: LandmarkRemarkTests_Setup{
    func test_ShouldStart(){
        self.mockLocationManager.permissionDenied = false
        self.locationVM.startLocationManager(completion: nil)
        
        XCTAssertEqual(self.locationVM.state, .inProgress)
    }
}

class when_LocationManager_Starts: LandmarkRemarkTests_Setup{
    func test_Should_Return_State_Started(){
        self.locationVM.startLocationManager(completion: nil)
        
        XCTAssertTrue(mockLocationManager.started)
    }
}

class when_LocationManagerStarts: LandmarkRemarkTests_Setup{
    func test_Should_Get_CurrentLocation(){
        self.locationVM.startLocationManager(completion: nil)
        
        XCTAssert(self.locationVM.currentLocation != nil)
    }
}

class when_Authorisation_Denied_After_LocationManager_Started: LandmarkRemarkTests_Setup{
    func test_Should_Return_State_NotAuthorised(){
        self.mockLocationManager.error = MockLocationManager.notAuthorisedError
        
        let exp = XCTestExpectation(description: "Location Denied after start")
        
        self.locationVM.startLocationManager { _, _ in
            XCTAssertEqual(self.locationVM.state, .notAuthorised)
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
    }
}
