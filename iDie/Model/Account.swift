//
//  Account.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl 
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import Foundation
import OHMySQL

class Account: NSObject, OHMappingProtocol {
    
   @objc var id: NSNumber?
   @objc var name: String?
   @objc var email: String?
   @objc var primarypassword: String?
   @objc var secondarypassword: String?
   @objc var confidantLastLogin: String?
         var isOwner: Bool = true

    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func mappingDictionary() -> [AnyHashable : Any]! {
        return ["id": "aid",
                "name": "name",
                "email": "email",
                "primarypassword": "primarypassword",
                "secondarypassword": "secondarypassword",
                "confidantLastLogin": "confidanttimestamp"
                ]
    }
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func mySQLTable() -> String! {
        return "account"
    }
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func primaryKey() -> String! {
        return "id"
    }
}
