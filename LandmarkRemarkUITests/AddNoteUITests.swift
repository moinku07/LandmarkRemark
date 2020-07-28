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
        app.otherElements.matching(identifier: "MyMarker").firstMatch.tap()
        
        let alert = app.alerts.matching(identifier: "AddNote").firstMatch
        let alertExists = alert.waitForExistence(timeout: 5)
        
        XCTAssertTrue(alertExists)
    }
    
    func test_app_should_save_text_typed_in_the_alert_textfield(){
        let myMarker = app.otherElements.matching(identifier: "MyMarker").firstMatch
        _ = myMarker.waitForExistence(timeout: 5)
        
        myMarker.tap()
        
        let alert = app.alerts.matching(identifier: "AddNote").firstMatch
        
        let note = "Test note \(Int.random(in: 1...1000))"
        
        alert.textFields["NoteInputField"].typeText(note)
        
        alert.buttons["SaveNote"].tap()
        
        sleep(5)
        
        app.alerts.firstMatch.buttons.firstMatch.tap()
        
        let count = app.otherElements.matching(NSPredicate(format: "label CONTAINS[c] %@", note)).count
        
        XCTAssertTrue(count > 0)
    }
}


