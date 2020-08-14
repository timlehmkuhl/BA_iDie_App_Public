//
//  RegisterViewController.swift
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

class RegisterViewController: UIViewController {

    
    @IBOutlet weak private var nameField: UITextField!
    @IBOutlet weak private var emailField: UITextField!
    @IBOutlet weak private var passwordField: UITextField!
    @IBOutlet weak private var secondaryPasswordField: UITextField!
    private let dm = DataManager.shared
    private let utils = Utils.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    /// Registriert einen neuen Account
    /// - Parameter sender: registrieren Button
    @IBAction private func registerAccount(_ sender: Any) {
        if(!utils.isValidEmail(emailField.text!)){
            utils.showAltertCustom(sender: self, tilestr: "Email", message: "Geben Sie eine gültige Email-Adresse ein!", buttonText: "OK")
            emailField.text = ""
            return
        }
        let existingAccount = dm.getAccountByMail(emailField.text!)
        if(existingAccount.email != nil){       //Test ob ein Account mit der Email bereits existiert
            utils.showAltertCustom(sender: self, tilestr: "Account", message: "Ein Account mit diese Email existiert bereits!", buttonText: "OK")
            return
        }
        if(passwordField.text!.count < utils.passwordLength || secondaryPasswordField.text!.count < utils.passwordLength){
            utils.showAltertCustom(sender: self, tilestr: "Passwort", message: "Ein Passwort muss mindestens 5 Zeichen enthalten. Bitte ändern Sie es.", buttonText: "OK")
            return
        }
        if(passwordField.text! == secondaryPasswordField.text!){
            utils.showAltertCustom(sender: self, tilestr: "Passwort", message: "Das persönliche Passwort und das vertrauten Passwort dürfen nicht übereinstimmen!", buttonText: "OK")
            return
        }
        if(nameField.text!.isEmpty){
            utils.showAltertCustom(sender: self, tilestr: "Name", message: "Bitte geben Sie einen Namen ein!", buttonText: "OK")
            return
        }
        let registerAccount = Account()
        registerAccount.email = emailField.text!.replacingOccurrences(of: " ", with: "")
        registerAccount.primarypassword = passwordField.text!.sha256() //[1]
        registerAccount.secondarypassword = secondaryPasswordField.text!.sha256() //[1]
        registerAccount.name = nameField.text!
        registerAccount.isOwner = true
        let executed = dm.insertNewAccount(registerAccount)
        
        if(executed){
            performSegue(withIdentifier: "showAfterRegister", sender: self)
        } else {
            utils.showAltertCustom(sender: self, tilestr: "Fehler", message: "Es ist ein Fehler aufgetreten. Prüfen Sie ihre Eingaben und Ihre Internetverbindung.", buttonText: "OK")
        }
    }
    

    
    /// return auf der Tastatur lässt Tastatur verschwinden
    /// - Parameter sender: textField
    @IBAction private func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    /// Ein touch außerhalb der Tastatur, lässt die Tastatur ausblenden
    /// - Parameters:
    ///   - touches: touch
    ///   - event: event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
