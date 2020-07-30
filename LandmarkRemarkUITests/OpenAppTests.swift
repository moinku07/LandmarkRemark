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
    func test_0_I_should_see_login_screen(){
        app.launchArguments.append("--uitesting-login")
        app.launch()
        
        let view = app.otherElements["LoginViewController"].firstMatch
        let exists = view.waitForExistence(timeout: 5.0)
        
        XCTAssertTrue(exists)
    }
}

class when_I_launch_the_app_and_enter_credentials: LandmarkRemarkUITests_Setup{
    func test_0_I_should_see_map_screen(){
        app.launchArguments.append("--uitesting-login")
        app.launch()
        
        let userNameField = app.textFields["Username"].firstMatch
        userNameField.tap()
        userNameField.typeText("johnsmith")
        
        let passwordField = app.secureTextFields["Password"].firstMatch
        passwordField.tap()
        passwordField.typeText("12345")
        
        app.buttons["Login"].firstMatch.tap()
        
        let view = app.otherElements["MapViewController"].firstMatch
        let exists = view.waitForExistence(timeout: 5.0)
        
        XCTAssertTrue(exists)
    }
}
