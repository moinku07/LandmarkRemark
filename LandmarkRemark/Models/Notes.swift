//
//  Notes.swift
//  LandmarkRemark
//
//  Created by St John Ambulance on 27/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Notes: Codable, Hashable{
    var note: String
    var geo: GeoPoint?
    var user: DocumentReference?
    var documentID: String?
    
        private enum CodingKeys: String, CodingKey {
            case note
            case geo
            case user
            case documentID
        }
    
    init(note: String, geo: GeoPoint, user: DocumentReference, documentID: String?){
        self.note = note
        self.user = user
        self.geo = geo
        self.documentID = documentID
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.note = try container.decodeIfPresent(String.self, forKey: .note) ?? ""
        self.user = try container.decodeIfPresent(DocumentReference.self, forKey: .user) ?? nil
        self.geo = try container.decodeIfPresent(GeoPoint.self, forKey: .geo) ?? nil
        self.documentID = try container.decodeIfPresent(String.self, forKey: .documentID) ?? nil
    }
    
    init(dictionary: [String: Any]) throws {
        self = try JSONDecoder().decode(Notes.self, from: JSONSerialization.data(withJSONObject: dictionary))
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
