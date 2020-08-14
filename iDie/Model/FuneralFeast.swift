//
//  FuneralFeast.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import Foundation
import OHMySQL

class FuneralFeast: NSObject, OHMappingProtocol {
    
    @objc var location: String?
    @objc var food: String?
    @objc var notes: String?
    @objc var accoundId: NSNumber?
    
    internal init(location: String? = nil, food: String? = nil, notes: String? = nil, accoundId: NSNumber? = nil) {
        self.location = location
        self.food = food
        self.notes = notes
        self.accoundId = accoundId
    }
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func mappingDictionary() -> [AnyHashable : Any]! {
      ["location": "location",
       "food": "food",
       "notes": "notes",
       "accoundId": "aid"
      ]
    }
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func mySQLTable() -> String! {
         return  "funeralfeast"
    }
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func primaryKey() -> String! {
        return "accoundId"
    }
    

}
