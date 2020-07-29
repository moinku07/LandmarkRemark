//
//  Notes.swift
//  LandmarkRemark
//
//  Created by Moin Uddin on 27/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Notes: Codable, Hashable{
    var note: String
    var geo: GeoPoint?
    var userName: String
    var documentID: String?
    
    init(note: String, geo: GeoPoint, userName: String, documentID: String?){
        self.note = note
        self.userName = userName
        self.geo = geo
        self.documentID = documentID
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.note = try container.decodeIfPresent(String.self, forKey: .note) ?? ""
        self.userName = try container.decodeIfPresent(String.self, forKey: .userName) ?? ""
        self.geo = try container.decodeIfPresent(GeoPoint.self, forKey: .geo) ?? nil
        self.documentID = try container.decodeIfPresent(String.self, forKey: .documentID) ?? nil
    }
    
    // parse/decode the dictionary and map to the structure properties
    init(dictionary: [String: Any]) throws {
        self = try JSONDecoder().decode(Notes.self, from: JSONSerialization.data(withJSONObject: dictionary))
    }
    
    // returns the structure properties with value as a dictionary
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
