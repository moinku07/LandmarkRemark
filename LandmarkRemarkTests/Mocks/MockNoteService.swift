//
//  MockNoteService.swift
//  LandmarkRemarkTests
//
//  Created by St John Ambulance on 27/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import Foundation
@testable import LandmarkRemark

class MockNoteService: NoteServiceProtocol{
    func getNotes(for user: User?, completion: @escaping ([Notes]?, Error?) -> Void) {
        
    }
    
    func saveNote(note: Notes, completion: @escaping (Notes?, Error?) -> Void) {
        DispatchQueue.global(qos: .default).async {
            var _note = note
            _note.documentID = "zgFAJ88787Ag"
            completion(_note, nil)
        }
    }
    
    
}
