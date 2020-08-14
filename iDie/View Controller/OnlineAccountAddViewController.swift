//
//  SocialMediaAddViewController.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import UIKit

class OnlineAccountAddViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak private var platformField: UITextField!
    @IBOutlet weak private var emailField: UITextField!
    @IBOutlet weak private var nicknameField: UITextField!
    @IBOutlet weak private var passwordFirstField: UITextField!
    @IBOutlet weak private var passwordLastField: UITextField!
    @IBOutlet weak private var detailsLabel: UILabel!
    @IBOutlet weak private var detailsField: UITextView!
    @IBOutlet weak private var navigationBar: UINavigationBar!
    @IBOutlet weak private var addButton: UIBarButtonItem!
    private let dm = DataManager.shared
    private let utils = Utils.shared
    //Weitergegebene Variablen
    var editMode: Bool = false
    var onlineAccountDetail: OnlineAccount?
    var isSocialMedia: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFields()
        utils.setTextViewBorder(textview: detailsField)
        if(editMode){
            platformField.text! = onlineAccountDetail!.platform!
            emailField.text! = onlineAccountDetail!.email!
            nicknameField.text! = onlineAccountDetail!.nickname!
            passwordLastField.text! = onlineAccountDetail!.passwortLast!
            passwordFirstField.text! = onlineAccountDetail!.passwortFirst!
            detailsField.text! = onlineAccountDetail!.details!
        }
        if(!dm.sessionAccount.isOwner){
            platformField.isEnabled = false
            detailsField.isEditable = false
            passwordLastField.isEnabled = false
            passwordFirstField.isEnabled = false
            emailField.isEnabled = false
            nicknameField.isEnabled = false
            addButton.isEnabled = false
            utils.setTextViewBackground(textview: detailsField)
        }
    }
    
    /// Setzt nötige Parameter für Textfelder und der Navigation Bar
    private func initFields() {
        if(!isSocialMedia!){
            detailsLabel.text = "Anmerkungen"
            self.navigationBar.topItem!.title = "Online Account"
        } else {
            self.navigationBar.topItem!.title = "Social Media"
        }
        platformField.delegate = self
        emailField.delegate = self
        nicknameField.delegate = self
        nicknameField.tag = 2
        passwordLastField.delegate = self
        passwordFirstField.tag = 1
        passwordLastField.tag = 1
        passwordFirstField.delegate = self
        detailsField.delegate = self
    }
    
    
    
    /// Fügt einen neuen Eintrag mit getätigten Eingaben an
    /// - Parameter sender: Sichern Button
    @IBAction private func addTapped(_ sender: Any) {
        if(platformField.text!.isEmpty){
            utils.showMissingInputAlert(sender: self, missing: "Plattform")
            return
        }
        var executed = false
        var isSocialMediaFlag: NSNumber = 0
        if(isSocialMedia!){
            isSocialMediaFlag = 1
        }
        let socialMedia = OnlineAccount(platform: platformField.text!, email: emailField.text!, nickname: nicknameField.text!, passwortFirst: passwordFirstField.text!, passwortLast: passwordLastField.text!, details: detailsField.text!, isSocialMedia: isSocialMediaFlag, accountId: dm.sessionAccount.id!)
        
        if(editMode){
            socialMedia.id = onlineAccountDetail!.id
            executed = dm.updateOnlineAccount(socialMedia)
        } else {
            executed = dm.insertOnlineAccount(socialMedia)
        }
        if(executed){
            dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadSocialMediaList"), object: nil)})
        } else {
            utils.showFailedSaveAltert(sender: self)
        }
    }
    
    
    /// Schließt die aktuelle Ansicht
    /// - Parameter sender: Abbrechen Button
    @IBAction private func chancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// Return Taste der Tastatur lässt Tastatur schließen
    /// - Parameter sender: <#sender description#>
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
    
    /// Schiebt die Ansicht nach oben, damit Tastatur das Eingabefeld nicht verdeckt
    /// - Parameter textField: Textfeld
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.tag == 1){
            utils.moveView(y: -200, sender: self)
        }
        if(textField.tag == 2){
            utils.moveView(y: -100, sender: self)
        }
    }
    
    /// Schiebt die Ansicht wieder in die Ausgangsposition
    /// - Parameter textField: Textfeld
    func textFieldDidEndEditing(_ textField: UITextField) {
         utils.moveView(y: 0, sender: self)
    }
    
    //Nur ein Zeichen in Passwortfeld
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField.tag == 1){
            return range.location < 1
        }
        return true
    }
    
    /// Schiebt die Ansicht nach oben, damit Tastatur das Eingabefeld nicht verdeckt
    /// - Parameter textView: Textview
    func textViewDidBeginEditing(_ textView: UITextView) {
        utils.moveView(y: -250, sender: self)
    }
    
    
    /// Schiebt die Ansicht wieder in die Ausgangsposition
    /// - Parameter textView: Textview
    func textViewDidEndEditing(_ textView: UITextView) {
         utils.moveView(y: 0, sender: self)
    }
    
    
    
}
