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
        let note = "This is my first note"
        
        beforeStart {
            //Any global initialization can go here
            
            app = XCUIApplication()
        }
        before({ _ in
            Given("I launch the app") { _, _ in
                app.launch()
            }
            
            Then("I should see my current location on a map"){ _, _ in
                let myMarker = app.otherElements.matching(identifier: "MyMarker").firstMatch
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
                
                _ = alert.waitForExistence(timeout: 5)
                alert.textFields["NoteInputField"].typeText(note)
                alert.buttons["SaveNote"].tap()
            }
            
            Then("It should save"){args, userInfo in
                let count = app.otherElements.matching(NSPredicate(format: "label CONTAINS[c] %@", note)).count
                
                XCTAssertTrue(count > 0)
            }
        })
        
        let bundle = Bundle(for: CucumberishInitializer.self)
        Cucumberish.executeFeatures(inDirectory: "Features", from: bundle, includeTags: nil, excludeTags: nil)
    }
}
