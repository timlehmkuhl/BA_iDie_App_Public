//
//  Contact.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl 
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import Foundation
import OHMySQL

class Contact: NSObject, OHMappingProtocol {
    
    @objc var id: NSNumber?
    @objc var name: String?
    @objc var status: String?
    @objc var email: String?
    @objc var phone: String?
    @objc var invite: NSNumber?
    @objc var message: String?
    @objc var accountId: NSNumber?
    
    
    internal init(name: String? = nil, status: String? = nil, email: String? = nil, phone: String? = nil, invite: NSNumber? = nil, message: String? = nil, accountId: NSNumber? = nil) {
        self.name = name
        self.status = status
        self.email = email
        self.phone = phone
        self.invite = invite
        self.message = message
        self.accountId = accountId
    }
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func mappingDictionary() -> [AnyHashable : Any]! {
        ["id": "cid",
        "name": "name",
        "status": "relation",
        "email": "email",
        "phone": "phone",
        "invite": "invite",
        "message": "message",
        "accountId": "aid",
        ]
    }
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func mySQLTable() -> String! {
        return "contact"
    }
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func primaryKey() -> String! {
        return "id"
    }

}
