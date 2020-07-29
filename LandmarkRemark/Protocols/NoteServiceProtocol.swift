//
//  NoteServiceProtocol.swift
//  LandmarkRemark
//
//  Created by Moin Uddin on 27/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import Foundation
// Blueprint for the Note Service
protocol NoteServiceProtocol {
    func saveNote(note: Notes, completion: @escaping (Notes?, Error?)->Void) // method to save a note with completion handler
    func getNotes(for user: User?, completion: @escaping ([Notes]?, Error?)->Void) // method to get all notes or notes for a specific user
    func search(term: String, completion: @escaping ([Notes]?, Error?)->Void) // method to search notes by a search term
    func removeGetNotesSubscription() // method to remove active subscription to getNotes
}
