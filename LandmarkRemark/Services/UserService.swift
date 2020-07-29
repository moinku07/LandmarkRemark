//
//  UserService.swift
//  LandmarkRemark
//
//  Created by Moin Uddin on 26/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import UIKit
import FirebaseFirestore

class UserService: UserServiceProtocol{
    var db: Firestore!
    
    init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    // createUser method tries to get an existing user and returns the user.
    // Otherwise, creates the user and returns the user.
    func createUser(user: User, completion: @escaping (User?, Error?)->Void){
        self.getUser(user: user, completion: completion)
    }
    
    // get the user document from Firestore
    private func getUser(user: User, completion: @escaping (User?, Error?)->Void){
        db.collection("users").whereField("userName", isEqualTo: user.userName).getDocuments { querySnapshot, error in
            if let error = error{
                completion(nil, error)
            }else if let data = querySnapshot?.documents.first?.data(){
                // record found
                do{
                    var _user = try User(dictionary: data)
                    _user.documentID = querySnapshot?.documents.first?.documentID
                    completion(_user, nil)
                }catch{
                    completion(nil, error)
                }
            }else{
                // no record found. so create one
                self.addUser(user: user, completion: completion)
            }
        }
    }
    
    // add/create a user and return the user
    private func addUser(user: User, completion: @escaping (User?, Error?)->Void){
        var ref: DocumentReference?
        ref = db.collection("users").addDocument(data: user.asDictionary) { error in
            if let error = error{
                completion(nil, error)
            }else if ref?.documentID != nil{
                var _user = user
                _user.documentID = ref!.documentID
                completion(_user, nil)
            }
        }
    }
}
