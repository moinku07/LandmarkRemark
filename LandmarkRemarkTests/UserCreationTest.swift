//
//  UserCreationTest.swift
//  LandmarkRemarkTests
//
//  Created by Moin Uddin on 26/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import XCTest
@testable import LandmarkRemark

class when_User_Information_Submitted: XCTestCase{
    func test_Should_Create_Or_Get_User(){
        let userService = MockUserService()
        let userVM = UserViewModel(service: userService)
        
        userVM.firstName = "John"
        userVM.lastName = "Smith"
        userVM.userName = "johnsmith"
        
        let exp = expectation(for: NSPredicate(block: { (obj, _) -> Bool in
            let vm = obj as! UserViewModel
            return vm.documentID != nil
        }), evaluatedWith: userVM, handler: nil)
        
        userVM.createUser()
        
        wait(for: [exp], timeout: 5.0)
        
    }
}
