//
//  UserCreationTest.swift
//  LandmarkRemarkTests
//
//  Created by Moin Uddin on 26/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import XCTest
@testable import LandmarkRemark

class when_User_Information_Submitted: LandmarkRemarkTests_Setup{
    func test_should_fail_when_no_internet(){
        userVM.firstName = "John"
        userVM.lastName = "Smith"
        userVM.userName = "johnsmith"
        userVM.password = "12345"
        
        let exp = XCTestExpectation(description: "User save")
        
        mockUserService.error = NSError(domain: String(describing: LRErrorCode.self), code: LRErrorCode.NoInternet.rawValue, userInfo: nil)
        
        userVM.createUser { user, error in
            
            XCTAssertEqual(LRErrorCode.NoInternet.rawValue, (error! as NSError).code)
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
    }
    
    func test_Should_Create_Or_Get_User(){
        userVM.firstName = "John"
        userVM.lastName = "Smith"
        userVM.userName = "johnsmith"
        
        let exp = expectation(for: NSPredicate(block: { (obj, _) -> Bool in
            let vm = obj as! UserViewModel
            return vm.documentID != nil
        }), evaluatedWith: userVM, handler: nil)
        
        userVM.createUser(completion: nil)
        
        wait(for: [exp], timeout: 5.0)
        
    }
}
