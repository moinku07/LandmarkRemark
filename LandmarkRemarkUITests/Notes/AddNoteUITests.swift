//
//  AddNoteUITests.swift
//  LandmarkRemarkUITests
//
//  Created by Moin Uddin on 24/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import XCTest
@testable import LandmarkRemark

class when_I_tap_on_my_current_location_marker: LandmarkRemarkUITests_Setup{
    
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
    
    func test_3_then_app_should_show_a_textinput_to_type_a_note(){
        let UserLocationPin = app.otherElements["UserLocationPin"].firstMatch
        _ = UserLocationPin.waitForExistence(timeout: 5)
        sleep(1)
        UserLocationPin.forceTap()
        
        let alert = app.alerts.matching(identifier: "AddNote").firstMatch
        var alertExists = alert.waitForExistence(timeout: 5)
        
        if !alertExists{
            // if there is alredy several pins, tap triger wrong pin instead the user location. so try tapping again
            UserLocationPin.tap()
            
            alertExists = alert.waitForExistence(timeout: 5.0)
        }
        
        XCTAssertTrue(alertExists)
    }
    
    func test_4_app_should_save_text_typed_in_the_alert_textfield(){
        let UserLocationPin = app.otherElements["UserLocationPin"].firstMatch
        _ = UserLocationPin.waitForExistence(timeout: 5)
        
        UserLocationPin.forceTap()
        
        let alert = app.alerts.matching(identifier: "AddNote").firstMatch
        let alertExists = alert.waitForExistence(timeout: 5.0)
        
        if !alertExists{
            // if there is alredy several pins, tap triger wrong pin instead the user location. so try tapping again
            UserLocationPin.tap()
            
            _ = alert.waitForExistence(timeout: 5.0)
        }
        
        let note = "Test note \(Int.random(in: 1...1000))"
        
        alert.textFields["NoteInputField"].typeText(note)
        
        alert.buttons["SaveNote"].tap()
        
        sleep(5)
        
        app.alerts.firstMatch.buttons.firstMatch.tap()
        
        let count = app.otherElements.matching(NSPredicate(format: "label CONTAINS[c] %@", note)).count
        
        XCTAssertTrue(count > 0)
    }
    
    func test_5_I_should_see_other_users_note(){
        // wait for 5 seconds to load the notes
        sleep(5)
        
        let count = app.otherElements.matching(NSPredicate(format: "identifier CONTAINS[c] %@", "Marker_")).count
        
        XCTAssertTrue(count > 0)
    }
    
    func test_6_I_can_search_note_or_user(){
        let searchField = app.searchFields.firstMatch
        _ = searchField.waitForExistence(timeout: 5.0)
        searchField.tap()
        searchField.typeText("Test note")
        
        app.buttons["Search"].tap()
        
        sleep(5)
        
        let testNoteMatchCount = app.otherElements.matching(NSPredicate(format: "label CONTAINS[c] %@", "Test note")).count
        
        XCTAssert(testNoteMatchCount > 0)
    }
}


