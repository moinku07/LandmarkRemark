//
//  LandmarkRemarkTests.swift
//  LandmarkRemarkTests
//
//  Created by Moin Uddin on 24/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import XCTest
@testable import LandmarkRemark

class LandmarkRemarkTests: XCTestCase {
    
    var mockLocationManager: MockLocationManager!
    var locationVM: LocationViewModel!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.mockLocationManager = MockLocationManager()
        self.mockLocationManager.locationManagerAvailable = true
        self.locationVM = LocationViewModel(locationManager: self.mockLocationManager)
    }
    
    func test_LocationManagerNotAvailable_DoesNotStart(){
        self.mockLocationManager.locationManagerAvailable = false
        
        self.locationVM.startLocationManager(completion: nil)
        
        XCTAssertEqual(self.locationVM.state, .notStarted)
    }
    
    func test_LocationNotAuthorised_DoesNotStart(){
        self.mockLocationManager.permissionDenied = true
        
        self.locationVM.startLocationManager(completion: nil)
        
        XCTAssertEqual(self.locationVM.state, .notStarted)
    }
    
    func test_LocationAuthorised_ReturnedError(){
        
    }
    
    func test_LocationAuthorised_ShouldStart(){
        self.mockLocationManager.permissionDenied = false
        self.locationVM.startLocationManager(completion: nil)
        
        XCTAssertEqual(self.locationVM.state, .inProgress)
    }
    
    func test_StartLocationManager(){
        self.locationVM.startLocationManager(completion: nil)
        
        XCTAssertTrue(mockLocationManager.started)
    }
    
    func test_AfterLocationManagerStarted_ShouldGetCurrentLocation(){
        self.locationVM.startLocationManager(completion: nil)
        
        XCTAssert(self.locationVM.currentLocation != nil)
    }
    
    func test_AuthorisationDeniedAfterLocationManagerStarted(){
        self.mockLocationManager.error = MockLocationManager.notAuthorisedError
        
        let exp = expectation(for: NSPredicate(block: { (obj, _) -> Bool in
            let vm = obj as! LocationViewModel
            return vm.state == .notAuthorised
        }), evaluatedWith: self.locationVM, handler: nil)
        
        self.locationVM.startLocationManager(completion: nil)
        
        wait(for: [exp], timeout: 2.0)
    }

    /*
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
 */

}

