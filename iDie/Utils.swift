//
//  Utils.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import UIKit

class Utils {
    
    static let shared = Utils()
    let passwordLength = 5
    

    /// Gibt eine benutzerdefinierte Meldung aus
    /// - Parameters:
    ///   - sender: ViewController
    ///   - tilestr: Titel der Meldung
    ///   - message: Inhalts-Nachricht
    ///   - buttonText: Text des Buttons
    func showAltertCustom(sender: UIViewController, tilestr: String, message: String, buttonText: String) {
        let wrongLoginAlert = UIAlertController(title: tilestr, message: message, preferredStyle: UIAlertController.Style.alert)
        wrongLoginAlert.addAction(UIAlertAction(title: buttonText, style: UIAlertAction.Style.default, handler: nil))
        sender.present(wrongLoginAlert, animated: true, completion: nil)
    }
    
    
    /// Gibt eine Meldung über eine fehlerhafte Internetverbindung beim Laden von Daten aus
    /// - Parameters:
    ///   - sender: ViewController
    ///   - viewGoback: Bool, ob zurück zur vorherigen View gegangen werden soll
    func showSuccesSaveAltert(sender: UIViewController, _ viewDismiss: Bool = false) {
        let alert = UIAlertController(title: "Erfolg", message: "Daten erfolgreich gespeichert", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            if(viewDismiss){
                sender.dismiss(animated: true, completion: nil)
            }
        }))
        sender.present(alert, animated: true, completion: nil)
    }
    
    
    /// Gibt eine Meldung über eine fehlerhafte Internetverbindung beim Speichern von Daten aus
    /// - Parameter sender: ViewController
    func showFailedSaveAltert(sender: UIViewController){
        showAltertCustom(sender: sender, tilestr: "Error", message: "Daten konnten nicht gespeichert werden. Überprüfen Sie die Internetverbindung", buttonText: "OK")
    }
    
    
    /// Gibt eine Meldung über eine fehlerhafte Internetverbindung beim Laden von Daten aus
    /// - Parameters:
    ///   - sender: ViewController
    ///   - viewGoback: Bool, ob zurück zur vorherigen View gegangen werden soll
    func showLoadingFailureAlert(sender: UIViewController, viewGoback: Bool) {
        let alert = UIAlertController(title: "Fehler", message: "Daten konnten nicht abgerufen werden. Überprüfen Sie Ihre Internetverbindung", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            if(viewGoback){
                sender.navigationController?.popViewController(animated: true)
            }
        }))
        sender.present(alert, animated: true, completion: nil)
    }
    
    func showMissingInputAlert(sender: UIViewController, missing: String){
        showAltertCustom(sender: sender, tilestr: "Fehlende Werte", message: "Folgende Werte sind Pflichtfelder: \(missing)!", buttonText: "OK")
    }
    
    func showMissingContactsAltert(sender: UIViewController) {
        self.showAltertCustom(sender: sender, tilestr: "Keine Kontakte", message: "Legen Sie zuerst Kontakte unter der Rubrik 'Kontakte' an!", buttonText: "OK")
    }
    
    
    /// Prüft, ob es sich syntaktisch um eine E-Mail handelt
    /// - Parameter emailtoTest: Email
    /// - Returns: true für gültige Mail
    func isValidEmail(_ emailtoTest: String) -> Bool {
        let expression = try! NSRegularExpression(pattern: ".+@.+\\..+", options: .caseInsensitive)
        return expression.firstMatch(in: emailtoTest, options: [], range: NSRange(location: 0, length: emailtoTest.count)) != nil
    }
    
    
    
    /// Bewegt die View um einen bestimmten Faktor nach oben oder unten
    /// - Parameters:
    ///   - y: Faktor
    ///   - sender: UIViewController
    func moveView(y: CGFloat, sender: UIViewController){
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
           sender.view.frame.origin.y = y
        })
    }
    
    /// Setzt einen Rahmen um Textviews
    /// - Parameter textview: Textview
    func setTextViewBorder(textview: UITextView){
        textview.layer.borderColor = UIColor.lightGray.cgColor
        textview.layer.borderWidth = 0.8
    }
    
    /// Setzt einen grauen Hintergrund in Textviews
    /// - Parameter textview: Textview
    func setTextViewBackground(textview: UITextView){
        textview.backgroundColor = UIColor.init(red: 250/255, green: 250/255, blue: 250/255, alpha: 255/255) //#fafafa
    }
    

    
}
