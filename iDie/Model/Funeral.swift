//
//  Funeral.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import Foundation
import OHMySQL

class Funeral: NSObject, OHMappingProtocol {
    
    @objc var kind: String?
    @objc var kindDetails: String?
    @objc var kindInfos: String?
    @objc var kindNotes: String?
    @objc var company: String?
    @objc var location: String?
    @objc var songs: String?
    @objc var speeker: String?
    @objc var speech: String?
    @objc var notes: String?
    @objc var accountId: NSNumber?
    
    internal init(company: String? = nil, location: String? = nil, songs: String? = nil, speeker: String? = nil, speech: String? = nil, notes: String? = nil, accountId: NSNumber? = nil) {
        self.company = company
        self.location = location
        self.songs = songs
        self.speeker = speeker
        self.speech = speech
        self.notes = notes
        self.accountId = accountId
    }
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func mappingDictionary() -> [AnyHashable : Any]! {
        ["kind": "kind",
         "kindDetails": "kinddetails",
         "kindInfos": "kindinfo",
         "kindNotes": "kindnotes",
         "company": "company",
         "location": "location",
         "songs": "songs",
         "speech": "speech",
         "speeker": "speeker",
         "notes": "notes",
         "accountId": "aid"
         ]
    }
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func mySQLTable() -> String! {
        "funeral"
    }
    
    //Implementierte Funktion des OHMappingProtocols des Frameworks OHMySQL
    func primaryKey() -> String! {
        "accountId"
    }
    

    private static let customtext = "Geben Sie hier weitere Infos an:"
    public static let custom = "Benutzerdefiniert"
    public static let kinds = [
        "Erdbestattung": [
            "Wahlgrab": "Größe und Ort kann frei ausgewählt werden. Es gibt viele Freiheiten und Gestaltungsmöglichkeiten. Im Gegensatz zu einem Reihengrab, sind die Kosten höher. Möglich sind auch Doppel- oder Familiengräber. Die Liegezeit ist verlängerbar.",
            "Reihengrab": "Der Ort auf der Grabstätte kann nicht frei ausgesucht werden, jedoch ist es dafür recht preiswert. Die Gestaltung und Größe sind ebenfalls eingeschränkt. Die Liegezeit ist nicht verlängerbar und beträgt 15-30 Jahre.",
            custom: customtext
        ],
        "Friedhofsbeisetzung einer Urne": [
            "Urnengrab": "Es findet eine Einäscherung statt. Die Urne wird in einem Grab bestattet. Es gibt einen festen Platz, dem Angedacht werden kann. Die Stelle kann nach Belieben gestaltet werden.",
            "Kolumbarium": "Eine Urne wird in Fächern einer Wand eingelassen, die auf einem Friedhof oder in einer Kirche steht. Jedes Fach hat einige eigene beliebige Beschriftung.",
            "Urnenstele": "Ähnlich wie Kolumbarium: Eine Urne wird in dekorierten Säulen eines Friedhofes eingelassen. Jedes Fach hat einige eigene beliebige Beschriftung.",
            custom: customtext
        ],
        "Naturbestattung": [
            "Waldbestattung": "Die Urne wird unter einem ausgewählten Baum begraben. Damit ist die Waldbestattung vor allem für naturverbundenen Menschen eine gute Wahl. Kosten ca. 2.000€ - 7.000€.",
            "Seebestattung": "Der Verstorbene wird eingeäschert und die Urne wird auf einem Schiff in Nord- oder Ostsee beigesetzt. Die Urne besteht aus einem wasserlöslichen Material. Die Bestattung ist sehr kostengünstig, da keine laufenden Kosten anfallen. Kosten ca. 2.000€ - 7.000€.",
            "Felsbestattung": "Die Urne wird unter einen Felsvorsprung bestattet oder die Asche in einem Felsgebiet verstreut. Wählbar sind Einzel – oder Gemeinschaftsgräber. In Deutschland illegal, jedoch in der Schweiz durchführbar. Kosten ca. 400€ – 5.000€.",
            "Almwiesenbestattung": "Die Asche des Verstorbenen wird auf einer Wiese in den Bergen verstreut. In Deutschland illegal, jedoch in der Schweiz durchführbar. Kosten ca. 2.000€.",
            "Luftbestattung": "Die Asche des Verstorbenen wird vom Bestatter aus einem Heißluftballon oder Flugzeug im Wind verstreut. Es wird eine Urkunde mit genauem Standort ausgestellt. In Deutschland illegal, jedoch in vielen europäischen Ländern durchführbar. Kosten ca. 2.000€ - 3.000€.",
            custom: customtext
        ],
        "Weitere Bestattungsformen": [
            "Diamantbestattung": "Aus der Asche des Verstorbenen wird in einem langwierigen Verfahren ein Diamant gepresst. Dieser kann als Schmuckstück getragen werden. Dazu wird nur ein Teil der Asche verwendet, weshalb es in Deutschland legal ist. Kosten ca. 5.000€ - 13.000€.",
            "Kryonik": "Der Körper wird konserviert, um ein evtl. späteres Widererwachen zu ermöglichen. Der Leichnam wird bei ca. -200°C aufbewahrt. In Deutschland illegal, jedoch in vielen europäischen Ländern und USA durchführbar. Kosten ca. 10.000$ – 100.000$.",
            "Körperspende": "Der Körper wird der Wissenschaft für Forschungen bereitgestellt. Der Andrang ist groß, da teilweise spätere Bestattungskosten übernommen werden. Deshalb gibt es oft eine Ablehnung oder eine Annahme mit verbundenen Kosten.",
            "Weltraumbestattung": "Ein Teil der Asche wird ins Weltall geschickt. Der Rest muss auf herkömmliche Weise bestattet werden. Kosten ca. 10.000€ – 25.000€.",
            "Muslimische Bestattung":"Die Bestattung wird nach der muslimischen Tradition durchgeführt. Dabei wird der Körper nach Mekka ausgerichtet, ohne Sarg bestattet. Nicht alle Friedhofssatzungen erlauben dieses. Die gesetzliche Ruhezeit liegt ebenfalls mit der Tradition im Konflikt. ",
            custom: customtext
        ]
        
    ] //[1]
    
    public static let kindKeyDetails = [
        "Erdbestattung": "Der Verstorbene wird in einem Sarg auf einem Friedhof unter der Erde beigesetzt. Diese Art ist vor allem im christlichen Glauben üblich und lange die Beliebteste in Deutschland. Es sind verschiedene Grabformen wählbar. Kosten ca. 4.000€ - 10.000€.",
        "Friedhofsbeisetzung einer Urne": "Der Verstorbene wird eingeäschert und die Asche befindet sich in einer Urne. Diese kann auf verschiedene Weise bestattet werden. Kosten ca. 4.000€ - 13.000€.",
        "Naturbestattung": "Diese Art der Bestattung ist vor allem für Naturliebhaber. Außerdem werden Angehörige nicht mit laufenden Kosten belastet.",
        "Weitere Bestattungsformen": "Es gibt weitere und besondere Arten der Bestattung. Jedoch sind nicht alle legal in Deutschland."
    ] //[1]
    
}

/*
Quelle der Informationen in kinds und kindKeyDetails:
[1] D.-I. D. Werner, „Bestattungsarten - welche sind erlaubt & verboten in Deutschland &
Kosten-Übersicht,“ [Online]. Available: https://www.bestattunginformation.de/bestattungsarten/. [Zugriff am 19 Mai 2020].
 */
