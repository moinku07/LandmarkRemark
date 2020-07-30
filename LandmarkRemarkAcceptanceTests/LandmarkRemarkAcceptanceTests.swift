//
//  LandmarkRemarkAcceptanceTests.swift
//  LandmarkRemarkAcceptanceTests
//
//  Created by Moin Uddin on 24/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import XCTest

extension XCUIElement {
    func forceTap() {
        coordinate(withNormalizedOffset: CGVector(dx:0.5, dy:0.5)).tap()
    }
}
