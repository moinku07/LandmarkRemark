//
//  CucumberishInitializer.swift
//  LandmarkRemarkAcceptanceTests
//
//  Created by Moin Uddin on 24/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import Foundation
import XCTest
import Cucumberish
@testable import LandmarkRemark

class CucumberishInitializer: NSObject{
    @objc public class func setupCucumberish(){
        //Using XCUIApplication only available in XCUI test targets not the normal Unit test targets.
        var app : XCUIApplication!
        let note = "Test note \(Int.random(in: 1...1000))"
        
        beforeStart {
            //Any global initialization can go here
            
            app = XCUIApplication()
        }
        before({ _ in
            Given("I launch the app") { _, _ in
                app.launch()
            }
            
            Then("I should see my current location on a map"){ _, _ in
                let UserLocationPin = app.otherElements["UserLocationPin"].firstMatch
                let UserLocationPinExists = UserLocationPin.waitForExistence(timeout: 5)
                
                XCTAssertTrue(UserLocationPinExists)
            }
            
            Given("I tap on my current location marker"){_, _ in
                app.launch()
                
                let UserLocationPin = app.otherElements["UserLocationPin"].firstMatch
                _ = UserLocationPin.waitForExistence(timeout: 5)
                
                UserLocationPin.tap()
            }
            
            When("I add note"){args, userInfo in
                let alert = app.alerts.matching(identifier: "AddNote").firstMatch
                _ = alert.waitForExistence(timeout: 5.0)
                alert.textFields["NoteInputField"].typeText(note)
                alert.buttons["SaveNote"].tap()
                
                sleep(5)
            }
            
            Then("It should save"){args, userInfo in
                app.alerts.firstMatch.buttons.firstMatch.tap()
                
                let count = app.otherElements.matching(NSPredicate(format: "label CONTAINS[c] %@", note)).count
                
                XCTAssertTrue(count > 0)
            }
            
            Given("I launch the app"){ _, _ in
                app.launch()
                sleep(5)
            }
            
            Then("I should see the note I saved at the location they were saved on the map"){ _, _ in
                let count = app.otherElements.matching(NSPredicate(format: "label CONTAINS[c] %@", "Test note")).count
                
                XCTAssertTrue(count > 0)
            }
            
            Given("I launch the app"){ _, _ in
                app.launch()
                
                sleep(5)
            }
            
            Then("I should see the location, text, and user-name of notes other users have saved"){ _, _ in
                let count = app.otherElements.matching(NSPredicate(format: "NOT (label CONTAINS[c] %@)", "Test note")).count
                
                XCTAssertTrue(count > 0)
            }
            
            Given("I launch the app"){ _, _ in
                app.launch()
                
                sleep(5)
            }
            
            Then("I should able to search for a note based on contained text or user-name"){ _, _ in
                let searchField = app.searchFields.firstMatch
                searchField.tap()
                searchField.typeText("Test note")
                
                app.buttons["Search"].tap()
                
                sleep(5)
                
                let testNoteMatchCount = app.otherElements.matching(NSPredicate(format: "label CONTAINS[c] %@", "Test note")).count
                
                XCTAssert(testNoteMatchCount > 0)
            }
        })
        
        let bundle = Bundle(for: CucumberishInitializer.self)
        Cucumberish.executeFeatures(inDirectory: "Features", from: bundle, includeTags: nil, excludeTags: nil)
    }
}
