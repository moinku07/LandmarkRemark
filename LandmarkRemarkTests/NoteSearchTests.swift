//
//  NoteSearchTests.swift
//  LandmarkRemarkTests
//
//  Created by Moin Uddin on 28/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import XCTest
import FirebaseFirestore
@testable import LandmarkRemark

class when_User_search: LandmarkRemarkTests_Setup{
    func test_should_find_the_note(){
        let exp = XCTestExpectation(description: "Search")
        
        noteVM.search(term: "a") { notes, error in
            if let notes = notes{
                XCTAssert(notes.count > 0)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
    }
}
