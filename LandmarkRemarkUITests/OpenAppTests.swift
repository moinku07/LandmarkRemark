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
        let myMarker = app.otherElements["MyMarker"].firstMatch
        let myMarkerExists = myMarker.waitForExistence(timeout: 5)
        
        XCTAssertTrue(myMarkerExists)
    }
    
    func test_I_should_see_other_users_note(){
        // wait for 5 seconds to load the notes
        sleep(5)
        
        let count = app.otherElements.matching(NSPredicate(format: "identifier CONTAINS[c] %@", "Marker_")).count
        
        XCTAssertTrue(count > 0)
    }
    
    func test_I_can_search_note_or_user(){
        app.textFields["SearchTextField"].typeText("Test note")
        
        sleep(5)
        
        let testNoteMatchCount = app.otherElements.matching(NSPredicate(format: "label CONTAINS[c] %@", "Test note")).count
        let otherMatchesCount = app.otherElements.matching(NSPredicate(format: "NOT (label CONTAINS[c] %@)", "Test note")).count
        
        XCTAssert(testNoteMatchCount > 0 && otherMatchesCount == 0)
        
        
        app.textFields["SearchTextField"].typeText("john")
        
        sleep(5)
        
        let testUserMatchCount = app.otherElements.matching(NSPredicate(format: "label CONTAINS[c] %@", "john")).count
        let otherUserMatchesCount = app.otherElements.matching(NSPredicate(format: "NOT (label CONTAINS[c] %@)", "john")).count
        
        XCTAssert(testUserMatchCount > 0 && otherUserMatchesCount == 0)
    }
}
