//
//  NoteService.swift
//  LandmarkRemark
//
//  Created by Moin Uddin on 27/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import UIKit
import FirebaseFirestore

class NoteService: NoteServiceProtocol{
    var db: Firestore!
    
    private var listener: ListenerRegistration? // registered listener for getting notes. default nil
    
    init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    // save the note on Firestore and return the status
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
    
    // get all notes or notes for a user
    func getNotes(for user: User?, completion: @escaping ([Notes]?, Error?)->Void){
        let noteCollection = db.collection("notes")
        
        if let user = user{
            noteCollection.whereField("userName", isEqualTo: user.userName)
        }
        
        listener?.remove()
        
        listener = noteCollection.addSnapshotListener { querySnapshot, error in
            if let error = error{
                completion(nil, error)
            }else if let notes = querySnapshot?.documents.map({try! $0.data(as: Notes.self)}) as? [Notes]{
                completion(notes, nil)
            }
        }
    }
    
    func search(term: String, completion: @escaping ([Notes]?, Error?) -> Void) {
        db.collection("notes")
            .whereField("note", isGreaterThanOrEqualTo: term.uppercased())
            .whereField("note", isLessThanOrEqualTo: term.lowercased() + "\u{f8ff}")
            .getDocuments { querySnapshot, error in
            if error != nil{
                self.search(byUsername: term, resultConcating: nil, completion: completion)
            }else if let notes = querySnapshot?.documents.map({try! $0.data(as: Notes.self)}) as? [Notes]{
                self.search(byUsername: term, resultConcating: notes.filter{$0.note.lowercased().contains(term.lowercased())}, completion: completion)
            }
        }
    }
    
    private func search(byUsername term: String, resultConcating notes: [Notes]?, completion: @escaping ([Notes]?, Error?) -> Void){
        db.collection("notes")
            .whereField("userName", isGreaterThanOrEqualTo: term.lowercased())
            .getDocuments { querySnapshot, error in
            if let error = error{
                completion(notes, error)
            }else if let userNotes = querySnapshot?.documents.map({try! $0.data(as: Notes.self)}) as? [Notes]{
                if notes != nil{
                    let allNotes = notes! + userNotes.filter{$0.userName.lowercased().contains(term.lowercased())}
                    completion(Array(Set(allNotes)), nil)
                }else{
                    completion(userNotes.filter{$0.userName.lowercased().contains(term.lowercased())}, nil)
                }
            }else{
                completion(notes, error)
            }
        }
    }
    
    func removeGetNotesSubscription() {
        self.listener?.remove()
        self.listener = nil
    }
}

