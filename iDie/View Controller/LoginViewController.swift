//
//  LoginViewController.swift
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

class LoginViewController: UIViewController {

    @IBOutlet weak private var emailfield: UITextField!
    @IBOutlet weak private var passwordField: UITextField!
    @IBOutlet weak private var loginButton: UIButton!
    @IBOutlet weak private var debugLoginButton: UIButton!
    @IBOutlet weak private var debugConfidantLogin: UIButton!
    
    private let DEBUGMODE = false
    private let DEBUGMAIL = "???"
    private let DEBUGPASSWORD = "???"
    private let dm = DataManager.shared
    private let utils = Utils.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(!DEBUGMODE){
            debugLoginButton.isHidden = true
            debugConfidantLogin.isHidden = true
        }
    }
    
    
    /// Versucht einen Login mit gehashten Passwort durchzuführen
    /// - Parameter sender: Login Button
    @IBAction private func tryLogin(_ sender: Any) {
        let email: String = emailfield.text!.replacingOccurrences(of: " ", with: "")
        let password: String = passwordField.text!.sha256() //[1]
        login(email: email, password: password)
    }
    
    
    /// Login wird versucht
    /// - Parameters:
    ///   - email: Email des Users oder Vertrauten
    ///   - password: Gehashtes Passwort des Users oder Vertrauten
    private func login(email: String, password: String){
        let account = dm.getAccountByMail(email)
        dm.sessionAccount = account
        if(email == account.email && password == account.primarypassword){ //Erfolgreicher Login eines Users
            performSegue(withIdentifier: "showMainView", sender: self)
        } else if(email == account.email && password == account.secondarypassword){ //Erfolgreicher Login eines Vertrauten
            account.isOwner = false
            account.confidantLastLogin = getCurrentTimeStamp()
            _ = dm.updateAccount(account) // setze timestamp
            let alert = UIAlertController(title: "Vertrauten Login", message: "Sie werden als Vertrauter eingeloggt und haben nur Leserechte.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in //Für Login OK bestätigen
            self.performSegue(withIdentifier: "showMainView", sender: self)
           }))
            alert.addAction(UIAlertAction(title: "Abbrechen", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {    //Fehlerhafter Login
            utils.showAltertCustom(sender: self, tilestr: "Fehlerhafter Login!", message: "Falsche Email-Adresse, falsches Passwort oder keine Internetverbindung. Bitte überprüfen Sie Ihre Eingaben und versuchen Sie es erneut.", buttonText: "OK")
        }
    }
    
    
    /// Gibt die aktuelle Systemzeit zurück
    /// - Returns: Systemzeit als String
    private func getCurrentTimeStamp() -> String {
        let date = DateFormatter()
        date.timeZone = TimeZone.current
        date.dateFormat = "dd.MM.yyyy HH:mm"
        return date.string(from: Date())
    }

    
    /// Login mit Debug Account
    /// - Parameter sender: Debug Login Button
    @IBAction private func debugPressed(_ sender: Any) {
        login(email: DEBUGMAIL, password: "???".sha256()) //[1]
    }
    
    /// Login mit Debug Vertrauten Account
    /// - Parameter sender: Debug Vertrauten Login Button
    @IBAction private func debugConfidantLogin(_ sender: Any) {
        login(email: DEBUGMAIL, password: DEBUGPASSWORD.sha256()) //[1]
    }
    
    
    /// Durck auf Return auf Tastatur lässt Tastatur verschwinden
    /// - Parameter sender: Textfields
    @IBAction private func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    

    ///  Ein touch außerhalb der Tastatur, lässt die Tastatur ausblenden
    /// - Parameters:
    ///   - touches: touch
    ///   - event: event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
