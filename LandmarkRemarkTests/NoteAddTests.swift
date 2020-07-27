//
//  NoteAddTests.swift
//  LandmarkRemarkTests
//
//  Created by St John Ambulance on 27/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import XCTest
@testable import LandmarkRemark

class when_User_submits_note: LandmarkRemarkTests_Setup{
    func test_should_save_note(){
        let mockNoteService = MockNoteService()
        let noteVM = NoteViewModel(service: mockNoteService, userVM: self.userVM)
        
        noteVM.note = "This is my first note"
        noteVM.geo = ""
        
        let exp = expectation(for: NSPredicate(block: { obj, _ -> Bool in
            
        }), evaluatedWith: noteVM, handler: nil)
        
        noteVM.saveNote(completion: nil)
        
        wait(for: [exp], timeout: 5.0)
    }
}
