//
//  DataManager.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import Foundation
import OHMySQL

/*
 Quelle
 [1] oleghnidets, „OHMySQL Reference,“ Mai 2018. [Online]. Available:
https://oleghnidets.github.io/OHMySQL/index.html. [Zugriff am 10 April 2020].
 */

class DataManager {
    
    static let shared = DataManager()
    
    var sessionAccount = Account()
    
    //Konstanten zur DB Verbindung
    private let username = "???"
    private let password = "???"
    private let host = "???"
    private let dbName = "???"
    private let port: UInt = 3306
    
    //Jeder folgende Zugriff der folgenden Konstante verwendet das OHMySQL Framework und dessen Funktionen [1]
    private let accessOhmysql = OHMySQLContainer.shared
    
    //Jeder folgende Zugriff der folgenden Konstante verwendet das OHMySQL Framework und dessen Funktionen [1]
    private let createQuery = OHMySQLQueryRequestFactory.self
    
    
    
    /// Erzeugt eine Verbindung zur Datenbank
    /// - Returns: storeCoordinator
    func initDatabaseConnection() -> OHMySQLStoreCoordinator {
        let dbAccessData = OHMySQLUser(userName: username, password: password, serverName: host, dbName: dbName, port: port, socket: "")
        let storeCoordinator = OHMySQLStoreCoordinator(user: dbAccessData!)
        storeCoordinator.encoding = .UTF8MB4
        storeCoordinator.connect()
        let queryContext = OHMySQLQueryContext()
        queryContext.storeCoordinator = storeCoordinator
        accessOhmysql.mainQueryContext = queryContext
        //Jeder folgende Zugriff des folgendes Rückgabewertes verwendet das OHMySQL Framework und dessen Funktionen [1]
        return storeCoordinator
    } //[1]
    
    
    /// Fügt ein Objekt der Db hinzu
    /// - Parameter object: Objekt einer Klasse, welche das OHMappingProtocol implementiert
    /// - Returns: true für Erfolg, false für Misserfolg
    private func insertObject(_ object: OHMappingProtocol) -> Bool {
        let db = initDatabaseConnection()
        accessOhmysql.mainQueryContext?.insertObject(object)
        guard (try? accessOhmysql.mainQueryContext?.save()) != nil else {
            db.disconnect()
            return false
        }
        db.disconnect()
        return true
    } //[1]
    
    
    /// Ändert ein Objekt in der Db
    /// - Parameter object: Objekt einer Klasse, welche das OHMappingProtocol implementiert
    /// - Returns: true für Erfolg, false für Misserfolg
    private func updateObject(_ object: OHMappingProtocol) -> Bool{
        let db = initDatabaseConnection()
        accessOhmysql.mainQueryContext?.updateObject(object)
        guard (try? accessOhmysql.mainQueryContext?.save()) != nil else {
            db.disconnect()
            return false
        }
        db.disconnect()
        return true
    } //[1]
    
    
    /// Löscht Objekt aus der DB
    /// - Parameter object: Objekt einer Klasse, welche das OHMappingProtocol implementiert
    /// - Returns: true für Erfolg, false für Misserfolg
    private func deleteObject(_ object: OHMappingProtocol) -> Bool {
        let db = initDatabaseConnection()
        accessOhmysql.mainQueryContext?.deleteObject(object)
        guard (try? accessOhmysql.mainQueryContext?.save()) != nil else {
            db.disconnect()
            return false
        }
        db.disconnect()
        return true
    } //[1]
    
    /// Gibt einen Account anhand einer Email-Adresse aus der DB zurück
    /// - Parameter email: email eines Accounts
    /// - Returns: Account der Email-Adresse
    public func getAccountByMail(_ email: String) -> Account {
        let db = initDatabaseConnection()
        var searchedAccount: Account = Account()
        let query = createQuery.select("account", condition: "email = '\(email)'")
        let response = try? accessOhmysql.mainQueryContext?.executeQueryRequestAndFetchResult(query)
        db.disconnect()
        if(response != nil && (!response!.isEmpty)){
            searchedAccount = Account()
            searchedAccount.map(fromResponse: response![0]) //Nur ein Account Objekt, also erstes
        }
        db.disconnect()
        return searchedAccount
    } //[1]
    
    
    /// Fügt einen neuen Account in die DB hinzu
    /// - Parameter ac: Objekt der Klasse Account
    /// - Returns: true für Erfolg, false für Misserfolg
    public func insertNewAccount(_ ac: Account) -> Bool {
        sessionAccount = ac
        return insertObject(ac)
    }
    
    
    /// Ändert einen vorhandenen Account in der DB
    /// - Parameter ac: Objekt der Klasse Account
    /// - Returns: true für Erfolg, false für Misserfolg
    public func updateAccount(_ ac: Account) -> Bool {
        let success = updateObject(sessionAccount)
        if(success){
            sessionAccount = ac
        }
        return success
    }
    
    
    /// Fügt einen neuen Kontakt in die DB hinzu
    /// - Parameter cont: Objekt der Klasse Contact
    /// - Returns: true für Erfolg, false für Misserfolg
    public func insertContact(_ cont: Contact) -> Bool {
        return insertObject(cont)
    }
    
    
    /// Ändert einen vorhandenen Kontakt in der DB
    /// - Parameter updatedContact: Objekt der Klasse Contact
    /// - Returns: true für Erfolg, false für Misserfolg
    public func updateContact(_ updatedContact: Contact) -> Bool{
        return updateObject(updatedContact)
    }
    
    
    /// Entfernt einen vorhandenen Kontakt in der DB
    /// - Parameter contact: Objekt der Klasse Contact
    /// - Returns: true für Erfolg, false für Misserfolg
    public func deleteContact(_ contact: Contact) -> Bool {
        return deleteObject(contact)
    }
    
    /// Gibt alle Kontakte des eingeloggten Accounts aus der DB zurück
    /// - Returns: Array der Accounts und true für Erfolg, false für Misserfolg
    public func getAllContactsFromAccount() -> ([Contact], Bool){
        let db = initDatabaseConnection()
        var contacts = [Contact]()
        let query = createQuery.select("contact", condition: "aid = '\(sessionAccount.id!)'")
        let response = try? accessOhmysql.mainQueryContext?.executeQueryRequestAndFetchResult(query)
        db.disconnect()
        
        guard let responseAll = response else {
            return (contacts, false)
        }
       
        for contactsResponse in responseAll {
            let tempContact = Contact()
            tempContact.map(fromResponse: contactsResponse)
            contacts.append(tempContact)
        }
        return (contacts, true)
    } //[1]
    
    
    /// Gibt alle Kontakte einer ID oder Kontaktname des eingeloggten Accounts aus der DB zurück
    /// - Parameters:
    ///   - name: Name eines Kontakts
    ///   - id: ID eines Kontakts
    /// - Returns: Array der Kontakte
    public func getContactByNameOrId(name : String?, id: NSNumber?) -> Contact {
        let db = initDatabaseConnection()
        var query: OHMySQLQueryRequest
        if(name != nil){
            query = createQuery.select("contact", condition: "aid = '\(sessionAccount.id!)' and name = '\(name!)'")
        } else {
            query = createQuery.select("contact", condition: "aid = '\(sessionAccount.id!)' and cid = '\(id!)'")
        }
        let response = try? accessOhmysql.mainQueryContext?.executeQueryRequestAndFetchResult(query)
        db.disconnect()
        let contact = Contact()
        contact.map(fromResponse: response![0])
        return contact
    } //[1]
    
    
    
    /// Fügt einen Erbgegenstand in die DB hinzu
    /// - Parameter heritage: Objekt der Klasse Heritage
    /// - Returns: true für Erfolg, false für Misserfolg
    public func insertHeritage(_ heritage : Heritage) -> Bool {
        let db = initDatabaseConnection()
        if(!db.isConnected){
            return false
        }
        accessOhmysql.mainQueryContext?.insertObject(heritage)
        try? accessOhmysql.mainQueryContext?.save()
        var i = 0
        var shares = ""
        for contact in heritage.contacts! {
            if (i < heritage.shares!.count){
               shares = heritage.shares![i]
            }
            let query = createQuery.insert("heritagecontactmanager", set: ["hid": heritage.id!, "cid": contact.id!, "aid": sessionAccount.id!, "share": shares])
          i = i+1
            try? accessOhmysql.mainQueryContext?.execute(query)
        }
        
        db.disconnect()
        return true
    } //[1]
    
    
    /// Löscht ein Erbgegenstand aus der DB
    /// - Parameter heritage: Objekt der Klasse Heritage
    /// - Returns:  true für Erfolg, false für Misserfolg
    public func deleteHeritage(_ heritage: Heritage) -> Bool {
        let db = initDatabaseConnection()
        let query = createQuery.delete("heritagecontactmanager", condition: "hid = '\(heritage.id!)'")
        try? accessOhmysql.mainQueryContext?.execute(query)
        let isHeritageDeleted = deleteObject(heritage)
        db.disconnect()
        return isHeritageDeleted
    } //[1]
    
    
    /// Ändert einen vorhandenen Erbgegenstand ohne Kontakte in der DB
    /// - Parameter heritage: Objekt der Klasse Heritage
    /// - Returns: true für Erfolg, false für Misserfolg
    public func updateHeritageWithoutContacts(_ heritage: Heritage) -> Bool {
        let db = initDatabaseConnection()
        if(!db.isConnected){
            return false
        }
        accessOhmysql.mainQueryContext?.updateObject(heritage)
        try? accessOhmysql.mainQueryContext?.save()
        let query = createQuery.delete("heritagecontactmanager", condition: "hid = '\(heritage.id!)'")
        try? accessOhmysql.mainQueryContext?.execute(query)
        var i = 0
        var shares = ""
        for contact in heritage.contacts! {
            if (i < heritage.shares!.count){
               shares = heritage.shares![i]
            }
            let query = createQuery.insert("heritagecontactmanager", set: ["hid": heritage.id!, "cid": contact.id!, "aid": sessionAccount.id!, "share": shares])
            i = i+1
           try? accessOhmysql.mainQueryContext?.execute(query)
        }
        db.disconnect()
        return true
    } //[1]
    
    
    /// Gibt alle Erbgegenstände des eigeloggtes Users aus der DB zurück
    /// - Parameter withContacts: true für mit Kontakten zurückgeben, false für ohne Kontakte zurückgeben
    /// - Returns: Array mit Erbgegenständen und true für Erfolg, false für Misserfolg
    public func getAllHeritages(withContacts: Bool) -> ([Heritage], Bool){
        let db = initDatabaseConnection()
        var heritages = [Heritage]()
        if(!db.isConnected){
            return (heritages, false)
        }
        let query = createQuery.select("heritage", condition: "aid = '\(sessionAccount.id!)'")
        let response = try? accessOhmysql.mainQueryContext?.executeQueryRequestAndFetchResult(query)
        db.disconnect()
        guard let responseAll = response else {
            return (heritages, false)
        }
        for heritageResponse in responseAll {
            let tempHeritage = Heritage()
            tempHeritage.map(fromResponse: heritageResponse)
            if(withContacts) {
                let contactsFormHeritage = getContactsFromHeritage(tempHeritage).0
                tempHeritage.contacts = contactsFormHeritage
                let sharesFromHeritage = getSharesFromHeritage(tempHeritage)
                tempHeritage.shares = sharesFromHeritage
            }
            heritages.append(tempHeritage)
        }
        return (heritages, true)
    } //[1]
    
    
    /// Gibt die Erbanteile eines Erbgegenstandes aus der DB zurück
    /// - Parameter heritage: Objekt der Klasse Heritage
    /// - Returns:Array der  Anteile eines Erbgegenstandes
    public func getSharesFromHeritage(_ heritage: Heritage) -> [String]{
        let db = initDatabaseConnection()
        var shares = [String]()
        let query = createQuery.select("heritagecontactmanager", condition: "aid = '\(sessionAccount.id!)' and hid = '\(heritage.id!)'")
        let response = try? accessOhmysql.mainQueryContext?.executeQueryRequestAndFetchResult(query)
        db.disconnect()
        guard let responseAll = response else {
                   return shares
        }
        for sharesResponse in responseAll {
            let sharesTemp = sharesResponse["share"]
            shares.append(sharesTemp as! String)
        }
        return shares
    } //[1]
    
    
    /// Gibt die Kontakte (Erbberechtigte) eines Erbgegenstandes aus der DB zurück
    /// - Parameter heritage: Objekt der Klasse Heritage
    /// - Returns: Array der  Anteile eines Erbgegenstandes
    public func getContactsFromHeritage(_ heritage: Heritage) -> ([Contact], Bool){
        let db = initDatabaseConnection()
        var contacts = [Contact]()
        if(!db.isConnected){
            return (contacts, false)
        }
        let query = createQuery.select("heritagecontactmanager", condition: "aid = '\(sessionAccount.id!)' and hid = '\(heritage.id!)'")
        let response = try? accessOhmysql.mainQueryContext?.executeQueryRequestAndFetchResult(query)
        db.disconnect()
        
        guard let responseAll = response else {
            return (contacts, false)
        }
        var contactIds = [NSNumber]()
        for contactIdsResponse in responseAll {
            contactIds.append(contactIdsResponse["cid"] as! NSNumber)
        }
        
        for id in contactIds {
            let responseContact = getContactByNameOrId(name: nil, id: id)
            contacts.append(responseContact)
        }
        return (contacts, true)
    } //[1]
    
    
    /// Fügt einen neuen online Account in die DB hinzu
    /// - Parameter onlineAccount: Objekt der Klasse OnlineAccount
    /// - Returns: true für Erfolg, false für Misserfolg
    public func insertOnlineAccount(_ onlineAccount: OnlineAccount) -> Bool {
        return insertObject(onlineAccount)
    }
    
    
    /// Ändert einen vorhandenen online Account in der DB
    /// - Parameter updatedOnlineAccount: Objekt der Klasse OnlineAccount
    /// - Returns: true für Erfolg, false für Misserfolg
    public func updateOnlineAccount(_ updatedOnlineAccount: OnlineAccount) -> Bool{
        return updateObject(updatedOnlineAccount)
    }
    
    
    /// Entfernt einen vorhandenen online Account aus der DB
    /// - Parameter onlineAccount: Objekt der Klasse OnlineAccount
    /// - Returns: true für Erfolg, false für Misserfolg
    public func deleteOnlineAccount(_ onlineAccount: OnlineAccount) -> Bool {
        return deleteObject(onlineAccount)
    }
    
    
    /// Gibt alle online Accounts des eingeloggten Accounts aus der DB zurück
    /// - Parameter isSocialMedia: true für Social Media Account, false für online Account
    /// - Returns: Array aus online Accounts und true für Erfolg, false für Misserfolg
    public func getAllOnlineAccounts(isSocialMedia: Bool) -> ([OnlineAccount], Bool){
        let db = initDatabaseConnection()
        var onlineAccount = [OnlineAccount]()
        var socialMediaFlag: NSNumber = 0
        if(isSocialMedia){
            socialMediaFlag = 1
        }
        let query = createQuery.select("onlineaccount", condition: "aid = '\(sessionAccount.id!)' and socialmedia = '\(socialMediaFlag)'")
        let response = try? accessOhmysql.mainQueryContext?.executeQueryRequestAndFetchResult(query)
        db.disconnect()
        
        guard let responseAll = response else {
            return (onlineAccount, false)
        }
        for onlineAccountResponse in responseAll {
            let tempOnlineAccount = OnlineAccount()
            tempOnlineAccount.map(fromResponse: onlineAccountResponse)
            onlineAccount.append(tempOnlineAccount)
        }
        return (onlineAccount, true)
    } //[1]
    
    
    /// Fügt ein Bankkonto in die DB hinzu
    /// - Parameter banking: Objekt der Klasse Banking
    /// - Returns: true für Erfolg, false für Misserfolg
    public func insertBanking(_ banking: Banking) -> Bool {
        return insertObject(banking)
    }
    
    
    /// Löscht ein vorhandenes Bankkonto aus der DB
    /// - Parameter banking: Objekt der Klasse Banking
    /// - Returns: true für Erfolg, false für Misserfolg
    public func deleteBanking(_ banking: Banking) -> Bool {
        return deleteObject(banking)
    }
    
    
    /// Ändert ein vorhandenes Bankkonto in der DB
    /// - Parameter updatedBanking: Objekt der Klasse Banking
    /// - Returns: true für Erfolg, false für Misserfolg
    public func updateBanking(_ updatedBanking: Banking) -> Bool{
        return updateObject(updatedBanking)
    }
    
    
    /// Gibt alle Bankkonten des eingeloggten Accounts aus der DB zurück
    /// - Returns: Array aus Banking Objekten und true für Erfolg, false für Misserfolg
    public func getAllBanking() -> ([Banking], Bool){
        let db = initDatabaseConnection()
        var banking = [Banking]()
        let query = createQuery.select("banking", condition: "aid = '\(sessionAccount.id!)'")
        let response = try? accessOhmysql.mainQueryContext?.executeQueryRequestAndFetchResult(query)
        db.disconnect()
        guard let responseAll = response else {
            return (banking, false)
        }
       
        for bankingResponse in responseAll {
            let tempBanking = Banking()
            tempBanking.map(fromResponse: bankingResponse)
            banking.append(tempBanking)
        }
        return (banking, true)
       
    } //[1]
    
    
    /// Fügt eine neue Orgranspende hinzu oder ändert eine Vorhandene in der DB
    /// - Parameter organDonation: Objekt der Klasse OrganDonation
    /// - Returns:  true für Erfolg, false für Misserfolg
    public func insertOrUpdateOrganDonation(_ organDonation: OrganDonation) -> Bool {
        var success = false
        let existingOrganDonation = getOrganDonation()
        if(existingOrganDonation.1 == false){
            success = insertObject(organDonation)
        } else{
            success = updateObject(organDonation)
       }
        return success
    }
    
    
    /// Löscht eine vorhandene Organspende aus der DB
    /// - Parameter organDonation: Objekt der Klasse OrganDonation
    /// - Returns: true für Erfolg, false für Misserfolg
    public func deleteOrganDonation(_ organDonation: OrganDonation) -> Bool {
        return deleteObject(organDonation)
    }
    
    
    /// Gibt eine Organspende aus der DB zurück
    /// - Returns: Objekt der Klasse OrganDonation und true für Erfolg, false für Misserfolg und true für keine Objekte, false für Objekte vorhanden
    public func getOrganDonation() -> (OrganDonation, Bool, Bool) {
        let db = initDatabaseConnection()
        let query = createQuery.select("organdonation", condition: "aid = '\(sessionAccount.id!)'")
        let response = try? accessOhmysql.mainQueryContext?.executeQueryRequestAndFetchResult(query)
        db.disconnect()
        let organdonation = OrganDonation()
        if(response == nil) {
            return (organdonation, false, false)
        }
        if(response!.count == 0){
            return (organdonation, false, true)
        }
        organdonation.map(fromResponse: response![0])
        return (organdonation, true, true)
        
    } //[1]
    
    
    
    /// Fügt eine neue Vollmacht in die DB
    /// - Parameter authority: Objekt der Klasse Authority
    /// - Returns: true für Erfolg, false für Misserfolg
    public func insertAuthority(authority: Authority) -> Bool {
        let success = insertObject(authority)
        let db = initDatabaseConnection()
        for contact in authority.contacts! {
            let query = createQuery.insert("authoritycontactmanager", set: ["auid": authority.id!, "cid": contact.id!, "aid": sessionAccount.id!])
            try? accessOhmysql.mainQueryContext?.execute(query)
        }
        db.disconnect()
        return success
    } //[1]
    
    
    /// Gibt alle  Vollmachten des eingeloggten Accounts aus der DB aus
    /// - Parameter withContacts: true für mit Kontakten, false ohne Kontakte
    /// - Returns: Array aus Vollmachten und true für Erfolg, false für Misserfolg und true für keine Objekte, false für Objekte vorhanden
    public func getAllAuthority(withContacts: Bool) -> ([Authority], Bool, Bool) {
        let db = initDatabaseConnection()
        var authority = [Authority]()
        let query = createQuery.select("authority", condition: "aid = '\(sessionAccount.id!)'")
        let response = try? accessOhmysql.mainQueryContext?.executeQueryRequestAndFetchResult(query)
        db.disconnect()
        if(response == nil) {
            return (authority, false, false)
        }
        if(response!.count == 0){
            return (authority, false, true)
        }
        guard let responseAll = response else {
             return (authority, false, true)
         }
         for authorityResponse in responseAll {
             let tempAuthority = Authority()
             tempAuthority.map(fromResponse: authorityResponse)
            if(withContacts){
                tempAuthority.contacts = getContactsFromAuthority(tempAuthority).0
            }
             authority.append(tempAuthority)
         }
        return (authority, true, true)
    } //[1]
    
    
    /// Gibt alle Kontakte einer Vollmacht aus der DB zurück
    /// - Parameter authority: Objekt der Klasse Authority
    /// - Returns: Array aus Kontakten und true für Erfolg, false für Misserfolg
    public func getContactsFromAuthority(_ authority: Authority) -> ([Contact], Bool){
        let db = initDatabaseConnection()
        var contacts = [Contact]()
        if(db.isConnected == false){
            return (contacts, false)
        }
        let query = createQuery.select("authoritycontactmanager", condition: "auid = '\(authority.id!)'")
        let response = try? accessOhmysql.mainQueryContext?.executeQueryRequestAndFetchResult(query)
        db.disconnect()
        guard let responseAll = response else {
            return (contacts, true)
        }
        var contactIds = [NSNumber]()
        for contactIdsResponse in responseAll {
            contactIds.append(contactIdsResponse["cid"] as! NSNumber)
        }
        for id in contactIds {
            let responseContact = getContactByNameOrId(name: nil, id: id)
            contacts.append(responseContact)
        }
        return (contacts, true)
    } //[1]
    
    
    /// Ändert eine vorhandene Vollmacht mit Kontakten in der DB
    /// - Parameter authority: Objekt der Klasse Authority
    /// - Returns:  true für Erfolg, false für Misserfolg
    public func updateAuthorityWithContacts(_ authority: Authority) -> Bool {
        let success =  updateObject(authority)
        let db = initDatabaseConnection()
        let query = createQuery.delete("authoritycontactmanager", condition: "auid = '\(authority.id!)'")
        try? accessOhmysql.mainQueryContext?.execute(query)
        for contact in authority.contacts! {
            let query = createQuery.insert("authoritycontactmanager", set: ["auid": authority.id!, "cid": contact.id!, "aid": sessionAccount.id!])
            try? accessOhmysql.mainQueryContext?.execute(query)
        }
        db.disconnect()
        return success
    } //[1]
    
    
    /// Löscht eine vorhandene Vollmacht aus der DB
    /// - Parameter authority: Objekt der Klasse Authority
    /// - Returns: true für Erfolg, false für Misserfolg
    public func deleteAuthority(_ authority: Authority) -> Bool {
        let db = initDatabaseConnection()
        let query = createQuery.delete("authoritycontactmanager", condition: "auid = '\(authority.id!)'")
        try? accessOhmysql.mainQueryContext?.execute(query)
        let isDeleted = deleteObject(authority)
        db.disconnect()
        return isDeleted
    } //[1]
    
    
    /// Fügt eine neue Bestattung hinzu oder ändert eine Vorhandene in der DB
    /// - Parameter funeral: Objekt der Klasse Funeral
    /// - Returns: true für Erfolg, false für Misserfolg
    public func insertOrUpdateFuneral(_ funeral: Funeral) -> Bool {
        var success = false
        let existingFuneral = getFuneral()
        if(existingFuneral.2 == false){
            return false
        }
        if(existingFuneral.1 == false){
            success = insertObject(funeral)
        } else{
            success = updateObject(funeral)
        }
        return success
    }
    
    
    /// Gibt die Bestattung des eingeloggten Accounts aus der DB zurück
    /// - Returns: Objekt der Klasse Funeral und true für Erfolg, false für Misserfolg und true für keine Objekte, false für Objekte vorhanden
    public func getFuneral() -> (Funeral, Bool, Bool) {
        let db = initDatabaseConnection()
        let query = createQuery.select("funeral", condition: "aid = '\(sessionAccount.id!)'")
        let response = try? accessOhmysql.mainQueryContext?.executeQueryRequestAndFetchResult(query)
        db.disconnect()
        let funeral = Funeral()
        if(response == nil) {
            return (funeral, false, false)
        }
        if(response!.count == 0){
            return (funeral, false, true)
        }
        funeral.map(fromResponse: response![0])
        return (funeral, true, true)
    } //[1]
    
    
    /// Fügt eine Kirche hinzu oder ändert eine Vorhandene in der DB
    /// - Parameter church: Objekt der Klasse Church
    /// - Returns:  true für Erfolg, false für Misserfolg
    public func insertOrUpdateChurch(_ church: Church) -> Bool {
        var success = false
        let existingChurch = getChurch()
        if(existingChurch.2 == false){
            return false
        }
        if(existingChurch.1 == false){
            success = insertObject(church)
        } else{
            success = updateObject(church)
        }
        return success
    }
    
    
    /// Gibt die Kirche des eingeloggten Accounts aus der DB zurück
    /// - Returns: Objekt der Klasse Church und true für Erfolg, false für Misserfolg und true für keine Objekte, false für Objekte vorhanden
    public func getChurch() -> (Church, Bool, Bool) {
        let db = initDatabaseConnection()
        let query = createQuery.select("church", condition: "aid = '\(sessionAccount.id!)'")
        let response = try? accessOhmysql.mainQueryContext?.executeQueryRequestAndFetchResult(query)
        db.disconnect()
        let church = Church()
        if(response == nil) {
            return (church, false, false)
        }
        if(response!.count == 0){
            return (church, false, true)
        }
        church.map(fromResponse: response![0])
        return (church, true, true)
    } //[1]
    
    
    /// Fügt einen Leichenschmaus hinzu oder ändert einen Vorhandenen in der DB
    /// - Parameter funeralFeast: Objekt der Klasse FuneralFeast
    /// - Returns: true für Erfolg, false für Misserfolg
    public func insertOrUpdateFuneralFeast(_ funeralFeast: FuneralFeast) -> Bool {
        var success = false
        let existingFeast = getFuneralFeast()
        if(existingFeast.2 == false){
           return false
        }
        if(existingFeast.1 == false){
           success = insertObject(funeralFeast)
        } else{
           success = updateObject(funeralFeast)
        }
        return success
    }
    
    
    /// Gibt ein Leichenschmaus des eingeloggten Accounts aus der DB zurück
    /// - Returns: Objekt der Klasse Leichenschmaus und true für Erfolg, false für Misserfolg und true für keine Objekte, false für Objekte vorhanden
    public func getFuneralFeast() -> (FuneralFeast, Bool, Bool) {
        let db = initDatabaseConnection()
        let query = createQuery.select("funeralfeast", condition: "aid = '\(sessionAccount.id!)'")
        let response = try? accessOhmysql.mainQueryContext?.executeQueryRequestAndFetchResult(query)
        db.disconnect()
        let funeralFeast = FuneralFeast()
        if(response == nil) {
            return (funeralFeast, false, false)
        }
        if(response!.count == 0){
            return (funeralFeast, false, true)
        }
        funeralFeast.map(fromResponse: response![0])
        return (funeralFeast, true, true)
    } //[1]

    
    /// Löscht Referenzen von Kontakten zu Vollmachten und Erbgegenständen aus der DB
    /// - Parameter contact: Objekt der Klasse Contact
    public func deleteReferencesFromContact(_ contact: Contact){
        let db = initDatabaseConnection()
        var query = createQuery.delete("heritagecontactmanager", condition: "aid = '\(sessionAccount.id!)' and cid = '\(contact.id!)'")
        try? accessOhmysql.mainQueryContext?.execute(query)
        query = createQuery.delete("authoritycontactmanager", condition: "aid = '\(sessionAccount.id!)' and cid = '\(contact.id!)'")
        try? accessOhmysql.mainQueryContext?.execute(query)
         db.disconnect()
    } //[1]
    
    
    /// Löscht alle EInträge, die zu dem eingeloggten Account gehören aus der DB
    /// - Returns: true für Erfolg, false für Misserfolg
    public func deleteAllFromAndWithAccount() -> Bool {
        let db = initDatabaseConnection()
        if(!db.isConnected){
            return false
        }
        var query = createQuery.delete("heritagecontactmanager", condition: "aid = '\(sessionAccount.id!)'")
        try? accessOhmysql.mainQueryContext?.execute(query)
        query = createQuery.delete("authoritycontactmanager", condition: "aid = '\(sessionAccount.id!)'")
        try? accessOhmysql.mainQueryContext?.execute(query)
         query = createQuery.delete("heritage", condition: "aid = '\(sessionAccount.id!)'")
        try? accessOhmysql.mainQueryContext?.execute(query)
         query = createQuery.delete("contact", condition: "aid = '\(sessionAccount.id!)'")
        try? accessOhmysql.mainQueryContext?.execute(query)
         query = createQuery.delete("onlineaccount", condition: "aid = '\(sessionAccount.id!)'")
        try? accessOhmysql.mainQueryContext?.execute(query)
         query = createQuery.delete("organdonation", condition: "aid = '\(sessionAccount.id!)'")
        try? accessOhmysql.mainQueryContext?.execute(query)
         query = createQuery.delete("banking", condition: "aid = '\(sessionAccount.id!)'")
        try? accessOhmysql.mainQueryContext?.execute(query)
         query = createQuery.delete("church", condition: "aid = '\(sessionAccount.id!)'")
        try? accessOhmysql.mainQueryContext?.execute(query)
         query = createQuery.delete("funeral", condition: "aid = '\(sessionAccount.id!)'")
        try? accessOhmysql.mainQueryContext?.execute(query)
        query = createQuery.delete("authority", condition: "aid = '\(sessionAccount.id!)'")
        try? accessOhmysql.mainQueryContext?.execute(query)
        query = createQuery.delete("church", condition: "aid = '\(sessionAccount.id!)'")
        try? accessOhmysql.mainQueryContext?.execute(query)
        query = createQuery.delete("funeralfeast", condition: "aid = '\(sessionAccount.id!)'")
        try? accessOhmysql.mainQueryContext?.execute(query)
        query = createQuery.delete("account", condition: "aid = '\(sessionAccount.id!)'")
        try? accessOhmysql.mainQueryContext?.execute(query)
        db.disconnect()
        return true
    } //[1]

}
