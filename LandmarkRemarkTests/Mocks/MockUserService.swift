//
//  MockUserService.swift
//  LandmarkRemarkTests
//
//  Created by Moin Uddin on 26/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import Foundation
@testable import LandmarkRemark

class MockUserService: UserServiceProtocol{
    
    func createUser(user: User, completion: @escaping (User?, Error?) -> Void) {
        DispatchQueue.global(qos: .default).async {
            var _user = user
            _user.documentID = "zgFAJ88787Ag"
            completion(_user, nil)
        }
    }
}
