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
                let myMarker = app.otherElements["MyMarker"].firstMatch
                let myMarkerExists = myMarker.waitForExistence(timeout: 5)
                
                XCTAssertTrue(myMarkerExists)
            }
            
            Given("I tap on my current location marker"){_, _ in
                app.launch()
                
                let myMarker = app.otherElements.matching(identifier: "MyMarker").firstMatch
                _ = myMarker.waitForExistence(timeout: 5)
                
                myMarker.tap()
            }
            
            When("I add note"){args, userInfo in
                let alert = app.alerts.matching(identifier: "AddNote").firstMatch
                
                sleep(5)
                
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
        })
        
        let bundle = Bundle(for: CucumberishInitializer.self)
        Cucumberish.executeFeatures(inDirectory: "Features", from: bundle, includeTags: nil, excludeTags: nil)
    }
}
