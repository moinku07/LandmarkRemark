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
    func test_should_save_note(){
        let mockNoteService = MockNoteService()
        let noteVM = NoteViewModel(service: mockNoteService)
        
        noteVM.noteText = "This is my first note"
        noteVM.geo = GeoPoint(latitude: -31.959299, longitude: 115.858496)
        //noteVM.userRef = 
        
        let exp = XCTestExpectation(description: "Note save")
        
        
        
        noteVM.saveNote { note, error in
            
            XCTAssertNotNil(note?.documentID, "Note was not saved")
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 10.0)
    }
}
