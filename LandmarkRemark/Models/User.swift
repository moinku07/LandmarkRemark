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
    var documentID: String?
    
    var ref: DocumentReference?{
        return UserService().getRef(forUser: self)
    }
    
//    private enum CodingKeys: String, CodingKey {
//        case firstName, lastName, userName
//    }
    
    init(firstName: String, lastName: String, userName: String, documentID: String?){
        self.firstName = firstName
        self.lastName = lastName
        self.userName = userName
        self.documentID = documentID
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        self.userName = try container.decodeIfPresent(String.self, forKey: .userName) ?? ""
        self.documentID = try container.decodeIfPresent(String.self, forKey: .documentID) ?? nil
    }
    
    init(dictionary: [String: Any]) throws {
        self = try JSONDecoder().decode(User.self, from: JSONSerialization.data(withJSONObject: dictionary))
    }
    
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
