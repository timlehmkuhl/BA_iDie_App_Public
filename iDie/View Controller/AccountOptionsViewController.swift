//
//  LogoutViewController.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl 
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import UIKit

class AccountOptionsViewController: UIViewController {

    @IBOutlet weak var confidentLastLoginLabel: UILabel!
    @IBOutlet weak private var editButton: UIButton!
    @IBOutlet weak private var deleteButton: UIButton!
    @IBOutlet weak private var greetingsLabel: UILabel!
    
    private let dm = DataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(dm.sessionAccount.confidantLastLogin == nil){
            confidentLastLoginLabel.text = "Noch nie"
        } else {
            confidentLastLoginLabel.text = dm.sessionAccount.confidantLastLogin
        }
        NotificationCenter.default.addObserver(self, selector: #selector(loadGreeting), name: NSNotification.Name(rawValue: "loadGreeting"), object: nil)
        greetingsLabel.text = "Hallo, \(dm.sessionAccount.name!)!"
        
        if(!dm.sessionAccount.isOwner){
            editButton.isHidden = true
            deleteButton.isHidden = true
            greetingsLabel.text = "Account von \(dm.sessionAccount.name!)"
        }
    }
    
    
    /// Begrüßung mit Name des Accounts wird gesetzt
    @objc private func loadGreeting() {
        greetingsLabel.text = "Hallo, \(dm.sessionAccount.name!)!"
    }
    
    
    /// Alle Daten des Accounts und Account wird gelöscht, nachdem durch eine Meldung bestätigt wird
    /// - Parameter sender: Account Löschen Button
    @IBAction private func deleteAccountTapped(_ sender: Any) {
         let alert = UIAlertController(title: "Account löschen", message: "Möchten Sie wirklich Ihren Account mit allen zugehörigen Daten löschen?", preferredStyle: UIAlertController.Style.alert)
         alert.addAction(UIAlertAction(title: "Ja", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            if(self.dm.deleteAllFromAndWithAccount()){
                self.performSegue(withIdentifier: "showLogout", sender: self)
            }
        }))
         alert.addAction(UIAlertAction(title: "Abbrechen", style: UIAlertAction.Style.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
    }
    
    
    /// Account wird ausgeloggt
    /// - Parameter sender: Logout Button
    @IBAction private func tapLogout(_ sender: Any) {
        dm.sessionAccount = Account()
        performSegue(withIdentifier: "showLogout", sender: self)
    }
    
    
   

}
