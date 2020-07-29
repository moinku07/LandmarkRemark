//
//  UserServiceProtocol.swift
//  LandmarkRemark
//
//  Created by Moin Uddin on 26/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol UserServiceProtocol {
    func createUser(user: User, completion: @escaping (User?, Error?)->Void) // method to create or get the user
}
