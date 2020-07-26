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
    func createUser(user: User, completion: @escaping (User?, Error?)->Void){
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
    
    private func getUser(user: User, completion: @escaping (User?, Error?)->Void){
        db.collection("users").whereField("userName", isEqualTo: user.userName).getDocuments { querySnapshot, error in
            if let error = error{
                completion(nil, error)
            }else if let data = querySnapshot?.documents.first?.data(){
                completion(nil, nil)
            }
        }
    }
    
    private func addUser(user: User, completion: @escaping (User?, Error?)->Void){
        
    }
}
