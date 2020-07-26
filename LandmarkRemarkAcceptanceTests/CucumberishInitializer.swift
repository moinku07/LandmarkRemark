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
                let myMarkerExists = myMarker.waitForExistence(timeout: 1)
                
                XCTAssertTrue(myMarkerExists)
            }
            
            Given("Given I tap on my current location marker"){_, _ in
                app.launch()
                
                app.otherElements.matching(identifier: "MyMarker").firstMatch.tap()
            }
            
            When("When I add note"){args, userInfo in
                app.alerts.matching(identifier: "AddNote").firstMatch.children(matching: .textField).matching(identifier: "NoteName").firstMatch.typeText("My first note")
                app.alerts.matching(identifier: "AddNote").firstMatch.children(matching: .textField).matching(identifier: "Save").firstMatch.tap()
            }
            
            Then("Then It should save"){args, userInfo in
                let okButton = app.alerts.matching(identifier: "NoteSaved").firstMatch.children(matching: .button).matching(identifier: "Save").firstMatch
                let okButtonExistance = okButton.waitForExistence(timeout: 10)
                okButton.tap()
                
                XCTAssertTrue(okButtonExistance)
            }
        })
        
        let bundle = Bundle(for: CucumberishInitializer.self)
        Cucumberish.executeFeatures(inDirectory: "Features", from: bundle, includeTags: nil, excludeTags: nil)
    }
}
