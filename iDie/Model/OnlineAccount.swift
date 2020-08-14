//
//  SocialMedia.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import Foundation
import OHMySQL

class OnlineAccount: NSObject, OHMappingProtocol {
    
    @objc var id: NSNumber?
    @objc var platform: String?
    @objc var email: String?
    @objc var nickname: String?
    @objc var passwortFirst: String?
    @objc var passwortLast: String?
    @objc var details: String?
    @objc var isSocialMedia: NSNumber?
    @objc var accountId: NSNumber?
    
    internal init(platform: String? = nil, email: String? = nil, nickname: String? = nil, passwortFirst: String? = nil, passwortLast: String? = nil, details: String? = nil, isSocialMedia: NSNumber? = nil, accountId: NSNumber? = nil) {
        self.platform = platform
        self.email = email
        self.nickname = nickname
        self.passwortFirst = passwortFirst
        self.passwortLast = passwortLast
        self.details = details
        self.isSocialMedia = isSocialMedia
        self.accountId = accountId
    }
    
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func mappingDictionary() -> [AnyHashable : Any]! {
        ["id": "sid",
        "platform": "platform",
        "email": "email",
        "nickname": "nickname",
        "passwortFirst": "passwortfirst",
        "passwortLast": "passwortlast",
        "details": "details",
        "isSocialMedia": "socialmedia",
        "accountId": "aid"
        ]
    }
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func mySQLTable() -> String! {
        return "onlineaccount"
    }
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func primaryKey() -> String! {
        return "id"
    }
    

}
