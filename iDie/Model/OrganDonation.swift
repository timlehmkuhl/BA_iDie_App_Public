//
//  OrganDonation.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import Foundation
import OHMySQL

class OrganDonation: NSObject, OHMappingProtocol {
    
    internal init(kind: String? = nil, kindDetail: String? = nil, details: String? = nil, accountid: NSNumber? = nil) {
        self.kind = kind
        self.details = details
        self.accountid = accountid
        self.kindDetail = kindDetail
    }
    
    @objc var kind: String?
    @objc var details: String?
    @objc var kindDetail: String?
    @objc var accountid: NSNumber?
    
    public static let kinds: [[String]] = [
        ["Ja", "Ja, ich erlaube, dass meinem Körper Organe und Gewebe nach der ärztlichen Feststellung meines Todes entnommen werden.", "Anmerkungen:"],
        ["Ja, mit Ausnahme", "Ja, mit Ausnahme unten angegebene Organe/Gewebe gestatte ich dies.", "Organe/Gewebe & Anmerkungen:"],
        ["Ja, für Ausgewählte", "Ja, jedoch nur für unten angegebene Organe/Gewebe gestatte ich dies.", "Organe/Gewebe & Anmerkungen:"],
        ["Nein", "Nein, einer Entnahme von Organen oder Geweben widerspreche ich.", "Anmerkungen:"],
        ["Person entscheidet", "Unten angegebene Person sollen über Ja oder Nein entscheiden.", "Anschrift des Entscheiders & Anmerkungen:"]
    ]// Quelle: Bundesgesundheitsministerium, [Online]. Available: https://www.bundesgesundheitsministerium.de/fileadmin/Dateien/3_Downloads/O/Organspende/Organspendeausweis_ausfuellbar.pdf. [Zugriff am 19 Mai 2020].
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func mappingDictionary() -> [AnyHashable : Any]! {
        ["kind": "kind",
        "details": "detail",
        "kindDetail": "kinddetail",
        "accountid": "aid"
        ]
    }
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func mySQLTable() -> String! {
        "organdonation"
    }
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func primaryKey() -> String! {
        "accountid"
    }
    

   

}
