//
//  Church.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import Foundation
import OHMySQL

class Church: NSObject, OHMappingProtocol {
    
    internal init(church: String? = nil, creed: String? = nil, pastor: String? = nil, psalm: String? = nil, songs: String? = nil, notes: String? = nil, accoundId: NSNumber? = nil) {
        self.church = church
        self.creed = creed
        self.pastor = pastor
        self.psalm = psalm
        self.songs = songs
        self.notes = notes
        self.accoundId = accoundId
    }
    
    @objc var church: String?
    @objc var creed: String?
    @objc var pastor: String?
    @objc var psalm: String?
    @objc var songs: String?
    @objc var notes: String?
    @objc var accoundId: NSNumber?
    
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func mappingDictionary() -> [AnyHashable : Any]! {
        ["church": "church",
         "creed": "creed",
         "psalm": "psalm",
         "pastor": "pastor",
         "notes": "notes",
         "songs": "songs",
         "accoundId": "aid"
        ]
    }
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func mySQLTable() -> String! {
        return "church"
    }
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func primaryKey() -> String! {
        return "accoundId"
    }
    
    
    

}

