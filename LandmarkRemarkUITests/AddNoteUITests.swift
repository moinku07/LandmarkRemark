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
    func test_then_app_should_show_a_textinput_to_type_a_note(){
        let UserLocationPin = app.otherElements["UserLocationPin"].firstMatch
        _ = UserLocationPin.waitForExistence(timeout: 5)
        
        UserLocationPin.tap()
        
        let alert = app.alerts.matching(identifier: "AddNote").firstMatch
        var alertExists = alert.waitForExistence(timeout: 5)
        
        if !alertExists{
            // if there is alredy several pins, tap triger wrong pin instead the user location. so try tapping again
            UserLocationPin.tap()
            
            alertExists = alert.waitForExistence(timeout: 5.0)
        }
        
        XCTAssertTrue(alertExists)
    }
    
    func test_app_should_save_text_typed_in_the_alert_textfield(){
        let UserLocationPin = app.otherElements["UserLocationPin"].firstMatch
        _ = UserLocationPin.waitForExistence(timeout: 5)
        
        UserLocationPin.tap()
        
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
}


