//
//  EditAccountViewController.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import UIKit
import CryptoSwift

/*
[1] M. Krzyzanowski, „CryptoSwift,“ [Online]. Available: https://cryptoswift.io/. [Zugriff
am 13 April 2020]. (Im Code wird lediglich die .sha256() Funktion dieses Frameworks genutzt)
*/

class EditAccountViewController: UIViewController {

    @IBOutlet weak private var nameField: UITextField!
    @IBOutlet weak private var emailField: UITextField!
    @IBOutlet weak private var pirmaryPasswordField: UITextField!
    @IBOutlet weak private var secondaryPasswordField: UITextField!
    
    private let dm = DataManager.shared
    private let utils = Utils.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.text = dm.sessionAccount.name
        emailField.text = dm.sessionAccount.email
    }
    
    /// Bearbeitete Account Details werden gespeichert
    /// - Parameter sender: Sichern Button
    @IBAction private func saveTapped(_ sender: Any) {
        let account = dm.sessionAccount
        var wasChanged = false
        let existingAccount = dm.getAccountByMail(emailField.text!)
        if(existingAccount.email != nil && dm.sessionAccount.email != existingAccount.email){       //Test ob ein Account mit der Email bereits existiert
            utils.showAltertCustom(sender: self, tilestr: "Account", message: "Ein Account mit diese Email existiert bereits!", buttonText: "OK")
            return
        }
        //Ceck ob Passwort lang genug ist
        if((pirmaryPasswordField.text!.count < utils.passwordLength && !pirmaryPasswordField.text!.isEmpty) || (secondaryPasswordField.text!.count < utils.passwordLength && !secondaryPasswordField.text!.isEmpty)){
            utils.showAltertCustom(sender: self, tilestr: "Passwort", message: "Ein Passwort muss mindestens 5 Zeichen enthalten. Bitte ändern Sie es.", buttonText: "OK")
            return
        }
        //Check ob breits vorhandene primär und sekundär Passwörter überein stimmen
        if((!secondaryPasswordField.text!.isEmpty && !pirmaryPasswordField.text!.isEmpty && pirmaryPasswordField.text! == secondaryPasswordField.text! ) || (pirmaryPasswordField.text!.sha256() == dm.sessionAccount.secondarypassword || secondaryPasswordField.text!.sha256() == dm.sessionAccount.primarypassword)){ //[1]
            utils.showAltertCustom(sender: self, tilestr: "Passwort", message: "Das persönliche Passwort und das Vertrauten-Passwort dürfen nicht übereinstimmen!", buttonText: "OK")
            return
        }
        if(!nameField.text!.isEmpty){
            account.name = nameField.text
            wasChanged = true
        }
        if(!emailField.text!.isEmpty){
            if(!utils.isValidEmail(emailField.text!)){
                utils.showAltertCustom(sender: self, tilestr: "Email", message: "Geben Sie eine gültige E-Mail Adresse ein", buttonText: "OK")
                return
            } else {
                account.email = emailField.text
                wasChanged = true
            }
        }
        if(!pirmaryPasswordField.text!.isEmpty){
            account.primarypassword = pirmaryPasswordField.text?.sha256() //[1]
            wasChanged = true
        }
        if(!secondaryPasswordField.text!.isEmpty){
            account.secondarypassword = secondaryPasswordField.text?.sha256() //[1]
            wasChanged = true
        }
        if(wasChanged){
            let success = dm.updateAccount(account)
            if(success){
                utils.showSuccesSaveAltert(sender: self, true)
            } else {
                utils.showFailedSaveAltert(sender: self)
            }
            
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadGreeting"), object: nil)
    }
    
    /// Schließt das aktuelle Fenster
    /// - Parameter sender: Abbrechen Button
    @IBAction private func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /// Ein touch außerhalb der Tastatur, lässt die Tastatur ausblenden
    /// - Parameters:
    ///   - touches: touch
    ///   - event: event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    /// Return Button auf der Tastatur soll Tastatur ausblenden
    @IBAction private func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }

}
