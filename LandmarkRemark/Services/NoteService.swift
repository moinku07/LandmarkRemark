//
//  NoteService.swift
//  LandmarkRemark
//
//  Created by St John Ambulance on 27/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import UIKit
import FirebaseFirestore

class NoteService: NoteServiceProtocol{
    var db: Firestore!
    
    init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    func saveNote(note: Notes, completion: @escaping (Notes?, Error?) -> Void) {
        var ref: DocumentReference?
        ref = db.collection("notes").addDocument(data: note.asDictionary) { error in
            if let error = error{
                completion(nil, error)
            }else if ref?.documentID != nil{
                var _note = note
                _note.documentID = ref!.documentID
                completion(_note, nil)
            }
        }
    }
    
    func getNotes(for user: User?, completion: @escaping ([Notes]?, Error?)->Void){
        let noteCollection = db.collection("notes")
        if let user = user{
            //db.collection("users")
        }
        noteCollection.getDocuments { querySnapshot, error in
            if let error = error{
                completion(nil, error)
            }else if let notes = querySnapshot?.documents.map({try! $0.data(as: Notes.self)}) as? [Notes]{
                completion(notes, nil)
            }
        }
    }
}

