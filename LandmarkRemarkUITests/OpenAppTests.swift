//
//  OpenAppTests.swift
//  LandmarkRemarkUITests
//
//  Created by Moin Uddin on 24/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import XCTest
@testable import LandmarkRemark

class when_I_launch_the_app: XCTestCase{
    func test_then_I_ShouldSeeMyCurrentLocation_OnMap(){
        let app = XCUIApplication()
        app.launch()
        
        // Ensure you have selected a Location for the UI Test. Otherwise, simulator will return Error and test will not pass
        
        let myMarker = app.otherElements.matching(identifier: "MyMarker").firstMatch
        let myMarkerExists = myMarker.waitForExistence(timeout: 5)
        
        XCTAssertTrue(myMarkerExists)
    }
}

class when_I_tap_on_my_current_location_marker: XCTestCase{
    func test_then_app_should_show_a_textinput_to_type_a_note(){
        let app = XCUIApplication()
        app.launch()
        
        app.otherElements.matching(identifier: "MyMarker").firstMatch.tap()
        
        let alert = app.alerts.matching(identifier: "AddNote").firstMatch
        let alertExists = alert.waitForExistence(timeout: 5)
        
        XCTAssertTrue(alertExists)
    }
    
    func test_app_should_save_text_typed_in_the_alert_textfield(){
        let app = XCUIApplication()
        app.launch()
        
        app.otherElements.matching(identifier: "MyMarker").firstMatch.tap()
        
        let alert = app.alerts.matching(identifier: "AddNote").firstMatch
        
        let note = "This is my first note"
        
        alert.textFields["NoteInputField"].typeText(note)
        
        alert.buttons["SaveNote"].tap()
        
        let count = app.otherElements.matching(NSPredicate(format: "label CONTAINS[c] %@", note)).count
        
        XCTAssertTrue(count > 0)
    }
}
