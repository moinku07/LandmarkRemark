//
//  UserViewModel.swift
//  LandmarkRemark
//
//  Created by Moin Uddin on 26/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import UIKit
import FirebaseFirestore

class UserViewModel{
    var firstName: String = ""
    var lastName: String = ""
    var userName: String = ""
    var documentID: String?
    
    var service: UserServiceProtocol
    
    private var user: User{
        return User(firstName: self.firstName, lastName: self.lastName, userName: self.userName, documentID: self.documentID)
    }
    
    init(service: UserServiceProtocol) {
        self.service = service
    }
    
    func createUser(completion: ((User?, Error?)->Void)?){
        self.service.createUser(user: user) { user, error in
            if let error = error{
                completion?(nil, error)
            }else{
                self.documentID = user?.documentID
                completion?(user, nil)
            }
        }
    }
}
