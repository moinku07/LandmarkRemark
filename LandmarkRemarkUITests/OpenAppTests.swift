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
    func test_then_I_Should_See_MyCurrentLocation_OnMap(){
        // Ensure you have selected a Location for the UI Test. Otherwise, simulator will return Error and test will not pass
        let UserLocationPin = app.otherElements["UserLocationPin"].firstMatch
        let UserLocationPinExists = UserLocationPin.waitForExistence(timeout: 5)
        
        XCTAssertTrue(UserLocationPinExists)
    }
    
    func test_I_should_see_other_users_note(){
        // wait for 5 seconds to load the notes
        sleep(5)
        
        let count = app.otherElements.matching(NSPredicate(format: "identifier CONTAINS[c] %@", "Marker_")).count
        
        XCTAssertTrue(count > 0)
    }
    
    func test_I_can_search_note_or_user(){
        let searchField = app.searchFields.firstMatch
        searchField.tap()
        searchField.typeText("Test note")
        
        app.buttons["Search"].tap()
        
        sleep(5)
        
        let testNoteMatchCount = app.otherElements.matching(NSPredicate(format: "label CONTAINS[c] %@", "Test note")).count
        
        XCTAssert(testNoteMatchCount > 0)
    }
}
