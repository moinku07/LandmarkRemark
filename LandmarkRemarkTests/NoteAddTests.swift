//
//  NoteAddTests.swift
//  LandmarkRemarkTests
//
//  Created by St John Ambulance on 27/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import XCTest
import FirebaseFirestore
@testable import LandmarkRemark

class when_User_submits_note: LandmarkRemarkTests_Setup{
    func test_should_not_save_when_no_userRef(){
        noteVM.noteText = "This is my first note"
        noteVM.geo = GeoPoint(latitude: -31.959299, longitude: 115.858496)
        
        let exp = XCTestExpectation(description: "Note save")
        
        noteVM.saveNote { note, error in
            
            XCTAssertEqual(LRErrorCode.ObjectNotFound.hashValue, (error! as NSError).code)
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
    }
    
    func test_should_not_save_when_no_internet(){
        createDemoUser()
        
        noteVM.noteText = "This is my first note"
        noteVM.geo = GeoPoint(latitude: -31.959299, longitude: 115.858496)
        noteVM.userRef = self.userVM.userRef
        
        let exp = XCTestExpectation(description: "Note save")
        
        mockNoteService.error = NSError(domain: String(describing: LRErrorCode.self), code: LRErrorCode.NoInternet.hashValue, userInfo: nil)
        
        noteVM.saveNote { note, error in
            
            XCTAssertEqual(LRErrorCode.NoInternet.hashValue, (error! as NSError).code)
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
    }
    
    func test_should_save_note(){
        createDemoUser()
        
        noteVM.noteText = "This is my first note"
        noteVM.geo = GeoPoint(latitude: -31.959299, longitude: 115.858496)
        noteVM.userRef = self.userVM.userRef
        
        let exp = XCTestExpectation(description: "Note save")
        
        noteVM.saveNote { note, error in
            
            XCTAssertNotNil(note?.documentID, "Note was not saved")
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
    }
}
