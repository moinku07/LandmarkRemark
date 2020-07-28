//
//  LandmarkRemarkTests.swift
//  LandmarkRemarkTests
//
//  Created by Moin Uddin on 24/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import XCTest
@testable import LandmarkRemark

class LandmarkRemarkTests_Setup: XCTestCase{
    var mockLocationManager: MockLocationManager!
    var locationVM: LocationViewModel!
    var mockUserService: MockUserService!
    var userVM: UserViewModel!
    var mockNoteService: MockNoteService!
    var noteVM: NoteViewModel!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        mockLocationManager = MockLocationManager()
        mockLocationManager.locationManagerAvailable = true
        locationVM = LocationViewModel(locationManager: self.mockLocationManager)
        
        mockUserService = MockUserService()
        userVM = UserViewModel(service: self.mockUserService)
        
        mockNoteService = MockNoteService()
        noteVM = NoteViewModel(service: mockNoteService)
    }
}
