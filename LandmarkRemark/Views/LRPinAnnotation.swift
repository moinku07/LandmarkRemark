//
//  LRPinAnnotation.swift
//  LandmarkRemark
//
//  Created by Moin Uddin on 26/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import UIKit
import MapKit

class LRPinAnnotation: NSObject, MKAnnotation, UIAccessibilityIdentification{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var accessibilityIdentifier: String?
    
    init(title: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
