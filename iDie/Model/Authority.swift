//
//  Authority.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import Foundation
import OHMySQL

class Authority: NSObject, OHMappingProtocol {
    
    internal init(kind: String? = nil, infos: String? = nil, notes: String? = nil, contacts: [Contact]? = nil, accountID: NSNumber? = nil) {
        self.kind = kind
        self.infos = infos
        self.notes = notes
        self.contacts = contacts
        self.accountID = accountID
    }
    
    
    @objc var id: NSNumber?
    @objc var kind: String?
    @objc var infos: String?
    @objc var notes: String?
    var contacts: [Contact]?
    @objc var accountID: NSNumber?
    
    
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func mappingDictionary() -> [AnyHashable : Any]! {
        ["id": "auid",
         "kind": "kind",
         "infos": "infos",
         "notes": "notes",
         "accountID": "aid"
        ]
    }
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func mySQLTable() -> String! {
        return "authority"
    }
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func primaryKey() -> String! {
        return "id"
    }
    

    public static let kinds = [
        "Generalvollmacht": "Die Generalvollmacht berechtigt den Vollmachtgeber in allen persönlichen und rechtlichen Angelegenheiten zu vertreten. Es wird eine sehr starke Macht übergeben. Die Gültigkeit gilt über den Tod hinaus", // [1]
        "Vorsorgevollmacht": "Die Vorsorgevollmacht berechtigt den Vollmachtgeber in gesundheitlichen, vermögensrechtlichen und persönlichen Angelegenheiten zu vertreten. Die Vollmacht wird erst gültig, wenn der Vollmachtgeber gesundheitlich nicht mehr in der Lage ist seinen Willen zu äußern.", // [1]
        "Bankvollmacht": "Mit einer Bankvollmacht hat der Bevollmächtigte das Recht bei einem Pflegebedarf oder Tod, voll auf das Konto des Vollmachtgebers zuzugreifen.",
        "Patientenverfügung": "Mit einer Patientenverfügung lässt sich festlegen, welche medizinische Maßnahmen durchgeführt werden soll und welche nicht. Die Patientenverfügung wird erst aktiv, wenn sich der Patient nicht selbst entscheiden kann.", // [4]
        "Bestattungsvollmacht": "Die Bestattungsvollmacht lässt sich Vorsorge über die Bestattung treffen. Hier wird dringend empfolen, die Personen mit einem Vertrauten-Zugang dieser App zu bevollmächtigen!", // [2]
        "Betreuungsverfügung": "Mit der Betreuungsverfügung lässt sich alles zu einer Betreuung festlegen, falls diese durch ein Unfall etc. benötigt wird.", // [3]
        "Sonstige":""]
    
}

/*
Quellen:

[1] Afilio - Gesellschaft für Vorsorge mbH, „Vorsorge­vollmacht und General­vollmacht: Das ist der Unterschied,“ [Online]. Available: https://www.afilio.de/post/recht/vorsorgedokumente/vorsorge-und-generalvollmacht-was-ist-der-unterschied. [Zugriff am 3 Mai 2020].

[2] Otto Beier GmbH, „Bestattungsvollmacht & Bestattungsverfügung: Vorsorge für Todesfall,“ 2020. [Online]. Available: https://www.pflege-durch-angehoerige.de/bestattungsvollmacht-bestattungsverfuegung/. [Zugriff am 3 Mai 2020].

[3] Aktion Mensch e.V., „Betreuungsverfügung,“ 19 Februar 2019. [Online]. Available: https://www.familienratgeber.de/rechte-leistungen/rechte/betreuungsverfuegung.php. [Zugriff am 3 Mai 2020].

[4] Bundesministerium für Gesundheit (BMG), „Patientenverfügung,“ 17 Dezember 2019. [Online]. Available: https://www.bundesgesundheitsministerium.de/patientenverfuegung.html. [Zugriff am 3 Mai 2020].
*/
