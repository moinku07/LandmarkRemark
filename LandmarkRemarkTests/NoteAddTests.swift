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
            
            XCTAssertEqual(LRErrorCode.ObjectNotFound.rawValue, (error! as NSError).code)
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
    }
    
    func test_should_not_save_when_no_internet(){
        let exp = XCTestExpectation(description: "Note save")
        
        userVM.firstName = "John"
        userVM.lastName = "Smith"
        userVM.userName = "johnsmith"
        
        self.noteVM.noteText = "This is my first note"
        self.noteVM.geo = GeoPoint(latitude: -31.959299, longitude: 115.858496)
        
        self.mockNoteService.error = NSError(domain: String(describing: LRErrorCode.self), code: LRErrorCode.NoInternet.rawValue, userInfo: nil)
        
        userVM.createUser { _, _ in
            self.noteVM.userRef = self.userVM.userRef
            self.noteVM.saveNote { note, error in
                XCTAssertEqual(LRErrorCode.NoInternet.rawValue, (error! as NSError).code)
                
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 5.0)
    }
    
    func test_should_save_note(){
        let exp = XCTestExpectation(description: "Note save")
        
        userVM.firstName = "John"
        userVM.lastName = "Smith"
        userVM.userName = "johnsmith"
        
        self.noteVM.noteText = "This is my first note"
        self.noteVM.geo = GeoPoint(latitude: -31.959299, longitude: 115.858496)
        
        userVM.createUser { _, _ in
            self.noteVM.userRef = self.userVM.userRef
            self.noteVM.saveNote { note, error in
                XCTAssertNotNil(note?.documentID, "Note was not saved")
                
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 5.0)
    }
}
