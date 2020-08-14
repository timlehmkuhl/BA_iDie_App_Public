//
//  Heritage.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import Foundation
import OHMySQL

class Heritage: NSObject, OHMappingProtocol {
    
    @objc var id: NSNumber?
    @objc var name: String?
    @objc var features: String?
    @objc var aid: NSNumber?
    var contacts: [Contact]?
    var shares: [String]?
    
    internal init(name: String? = nil, features: String? = nil, aid: NSNumber? = nil, contacts: [Contact]? = nil, shares: [String]? = nil) {
        self.name = name
        self.features = features
        self.aid = aid
        self.contacts = contacts
        self.shares = shares
    }
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func mappingDictionary() -> [AnyHashable : Any]! {
        ["id": "hid",
         "name": "name",
         "features": "features",
         "aid": "aid"
        ]
    }
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func mySQLTable() -> String! {
        "heritage"
    }
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func primaryKey() -> String! {
        "id"
    }
    
}
