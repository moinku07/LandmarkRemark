//
//  User.swift
//  LandmarkRemark
//
//  Created by Moin Uddin on 26/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import UIKit
import FirebaseFirestore

struct User: Codable, Hashable{
    var firstName: String
    var lastName: String
    var userName: String
    var password: String
    var documentID: String?
    
    init(firstName: String, lastName: String, userName: String, password: String,  documentID: String?){
        self.firstName = firstName
        self.lastName = lastName
        self.userName = userName
        self.password = password
        self.documentID = documentID
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        self.userName = try container.decodeIfPresent(String.self, forKey: .userName) ?? ""
        self.password = try container.decodeIfPresent(String.self, forKey: .password) ?? ""
        self.documentID = try container.decodeIfPresent(String.self, forKey: .documentID) ?? nil
    }
    
    // parse/decode dictionary
    init(dictionary: [String: Any]) throws {
        self = try JSONDecoder().decode(User.self, from: JSONSerialization.data(withJSONObject: dictionary))
    }
    
    // returns the sturcture as a dictionary
    var asDictionary : [String:Any] {
      let mirror = Mirror(reflecting: self)
      let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
        guard let label = label else { return nil }
        if label == "documentID"{
            return nil
        }
        return (label, value)
      }).compactMap { $0 })
      return dict
    }
}
