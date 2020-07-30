//
//  LRAlertController.swift
//  LandmarkRemark
//
//  Created by St John Ambulance on 30/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import UIKit

final class LRAlertController{
    // method to present an alert
    class func showAlert(vc: UIViewController, title: String, message: String, buttons: [String]){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        buttons.forEach{
            alert.addAction(UIAlertAction(title: $0, style: UIAlertAction.Style.default, handler: nil))
        }
        vc.present(alert, animated: true)
    }
}
