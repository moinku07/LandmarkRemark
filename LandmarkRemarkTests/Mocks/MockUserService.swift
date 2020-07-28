//
//  MockUserService.swift
//  LandmarkRemarkTests
//
//  Created by Moin Uddin on 26/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import Foundation
import FirebaseFirestore
@testable import LandmarkRemark

class MockUserService: UserServiceProtocol{
    var error: Error?
    
    func getRef(forUser user: User)->DocumentReference? {
        guard let documentID = user.documentID else{
            return nil
        }
        return Firestore.firestore().collection("user").document(documentID)
    }
    
    func createUser(user: User, completion: @escaping (User?, Error?) -> Void) {
        DispatchQueue.global(qos: .default).async {
            if let error = self.error{
                completion(nil, error)
            }else{
                var _user = user
                _user.documentID = "zgFAJ88787Ag"
                completion(_user, nil)
            }
        }
    }
}
