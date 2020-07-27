//
//  NoteServiceProtocol.swift
//  LandmarkRemark
//
//  Created by St John Ambulance on 27/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import Foundation

protocol NoteServiceProtocol {
    func saveNote(note: Notes, completion: @escaping (Notes?, Error?)->Void)
    func getNotes(for user: User?, completion: @escaping ([Notes]?, Error?)->Void)
}
