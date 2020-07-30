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
            
            app.launchArguments.append("--uitesting")
        }
        
        before({ _ in
            //Scenario: As a user when I launch the app for the first time it should ask location permission
            Given("I launch the app"){ _, _ in
                XCTestCase().addUIInterruptionMonitor(withDescription: "Location Services"){ alert -> Bool in
                    if alert.buttons["Allow"].exists {
                        alert.buttons["Allow"].tap()
                    }
                    return true
                }
                app.launch()
            }
            
            Then("I should see location permission alert"){ _, _ in
                app.tap()
            }
            
            
            // Scenario: As a user I can see my current location on a map
            Given("I launch the app") { _, _ in
                app.launch()
            }
            
            Then("I should see my current location on a map"){ _, _ in
                let UserLocationPin = app.otherElements["UserLocationPin"].firstMatch
                let UserLocationPinExists = UserLocationPin.waitForExistence(timeout: 5)
                
                XCTAssertTrue(UserLocationPinExists)
            }
            
            // Scenario: As a user I can save a short note at my current location
            Given("I tap on my current location marker"){_, _ in
                app.launch()
                
                let UserLocationPin = app.otherElements["UserLocationPin"].firstMatch
                _ = UserLocationPin.waitForExistence(timeout: 5)
                
                UserLocationPin.forceTap()
            }
            
            When("I add note"){args, userInfo in
                let alert = app.alerts.matching(identifier: "AddNote").firstMatch
                let exists = alert.waitForExistence(timeout: 5.0)
                
                if !exists{
                    app.otherElements["UserLocationPin"].firstMatch.forceTap()
                    _ = alert.waitForExistence(timeout: 5.0)
                }
                
                alert.textFields["NoteInputField"].typeText(note)
                alert.buttons["SaveNote"].tap()
                
                sleep(5)
            }
            
            Then("It should save"){args, userInfo in
                app.alerts.firstMatch.buttons.firstMatch.tap()
                
                let count = app.otherElements.matching(NSPredicate(format: "label CONTAINS[c] %@", note)).count
                
                XCTAssertTrue(count > 0)
            }
            
            
            //Scenario: As a user I can see notes that I have saved at the location they were saved on the map
            Given("I launch the app"){ _, _ in
                app.launch()
                sleep(5)
            }
            
            Then("I should see the note I saved at the location they were saved on the map"){ _, _ in
                let count = app.otherElements.matching(NSPredicate(format: "label CONTAINS[c] %@", "Test note")).count
                
                XCTAssertTrue(count > 0)
            }
            
            //Scenario: As a user I can see the location, text, and user-name of notes other users have saved
            Given("I launch the app"){ _, _ in
                app.launch()
                
                sleep(5)
            }
            
            Then("I should see the location, text, and user-name of notes other users have saved"){ _, _ in
                let count = app.otherElements.matching(NSPredicate(format: "NOT (label CONTAINS[c] %@)", "Test note")).count
                
                XCTAssertTrue(count > 0)
            }
            
            // Scenario: As a user I have the ability to search for a note based on contained text or user-name
            Given("I launch the app"){ _, _ in
                app.launch()
                
                sleep(5)
            }
            
            Then("I should able to search for a note based on contained text or user-name"){ _, _ in
                let searchField = app.searchFields.firstMatch
                _ = searchField.waitForExistence(timeout: 5.0)
                
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
