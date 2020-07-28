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
    func test_then_I_ShouldSeeMyCurrentLocation_OnMap(){
        app.launch()
        
        // Ensure you have selected a Location for the UI Test. Otherwise, simulator will return Error and test will not pass
        let myMarker = app.otherElements["MyMarker"].firstMatch
        let myMarkerExists = myMarker.waitForExistence(timeout: 5)
        
        XCTAssertTrue(myMarkerExists)
    }
}
