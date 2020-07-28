//
//  NoteViewModel.swift
//  LandmarkRemark
//
//  Created by St John Ambulance on 27/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class NoteViewModel{
    var noteText: String = ""
    var userRef: DocumentReference?
    var geo: GeoPoint?
    var documentID: String?
    
    var service: NoteServiceProtocol!
    
    private var note: Notes{
        return Notes(note: noteText, geo: geo!, user: self.userRef!, documentID: documentID)
    }
    
    init(service: NoteServiceProtocol) {
        self.service = service
    }
    
    func saveNote(completion: @escaping (Notes?, Error?)->Void){
        if self.userRef == nil{
            let error = NSError(domain: String(describing: LRErrorCode.self), code: LRErrorCode.ObjectNotFound.rawValue, userInfo: nil)
            
            completion(nil, error)
            return
        }
        self.service.saveNote(note: self.note) { _note, error in
            completion(_note, error)
        }
    }
    
    func getNotes(forUser user: User?, completion: @escaping ([Notes]?, Error?)->Void){
        self.service.getNotes(for: user) { notes, error in
            completion(notes, error)
        }
    }
    
    func removeGetNoteSubscription(){
        self.service.removeGetNotesSubscription()
    }
}
