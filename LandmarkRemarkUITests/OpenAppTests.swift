//
//  OpenAppTests.swift
//  LandmarkRemarkUITests
//
//  Created by Moin Uddin on 24/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import XCTest
@testable import LandmarkRemark

class when_I_launch_the_app: LandmarkRemarkUITests_Setup{
    // since the test runs alphabetical ascending order, I set 0 to do this test first
    func test_0_I_should_see_location_permission_if_not_authorised(){
        addUIInterruptionMonitor(withDescription: "Location Services"){ alert -> Bool in
            if alert.buttons["Allow"].exists {
                alert.buttons["Allow"].tap()
            }
            return true
        }
        app.launch()
        app.tap()
    }
    
    func test_1_then_I_Should_See_MyCurrentLocation_OnMap(){
        // Ensure you have selected a Location for the UI Test. Otherwise, simulator will return Error and test will not pass
        let UserLocationPin = app.otherElements["UserLocationPin"].firstMatch
        let UserLocationPinExists = UserLocationPin.waitForExistence(timeout: 5)
        
        XCTAssertTrue(UserLocationPinExists)
    }
    
    func test_2_I_should_see_other_users_note(){
        // wait for 5 seconds to load the notes
        sleep(5)
        
        let count = app.otherElements.matching(NSPredicate(format: "identifier CONTAINS[c] %@", "Marker_")).count
        
        XCTAssertTrue(count > 0)
    }
}
