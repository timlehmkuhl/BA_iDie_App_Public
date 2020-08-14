//
//  Banking.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl 
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import Foundation
import OHMySQL

class Banking: NSObject, OHMappingProtocol {


    @objc var id: NSNumber?
    @objc var bank: String?
    @objc var kind: String?
    @objc var iban: String?
    @objc var bic: String?
    @objc var balance: NSNumber?
    @objc var notes: String?
    @objc var accoundID: NSNumber?
    
    public static let kinds = ["Girokonto", "Tagesgeldkonto", "Sparbuch", "Kreditkarte", "Depot", "Kredit", "Sonstige"]
    
    internal init(bank: String? = nil, kind: String? = nil, iban: String? = nil, bic: String? = nil, balance: NSNumber? = nil, notes: String? = nil, accoundID: NSNumber? = nil) {
        self.bank = bank
        self.kind = kind
        self.iban = iban
        self.bic = bic
        self.balance = balance
        self.notes = notes
        self.accoundID = accoundID
    }
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func mappingDictionary() -> [AnyHashable : Any]! {
        ["id": "bid",
        "bank": "bank",
        "kind": "kind",
        "iban": "iban",
        "bic": "bic",
        "balance": "balance",
        "notes": "notes",
        "accoundID": "aid"
        ]
    }
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func mySQLTable() -> String! {
        return "banking"
    }
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func primaryKey() -> String! {
        return "id"
    }
    



}
