//
//  ContactAddViewController.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl 
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import UIKit
import CryptoSwift

class ContactAddViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate{

    @IBOutlet weak private var nameField: UITextField!
    @IBOutlet weak private var statusField: UITextField!
    @IBOutlet weak private var emailField: UITextField!
    @IBOutlet weak private var phoneField: UITextField!
    @IBOutlet weak private var inviteSwitch: UISwitch!
    @IBOutlet weak private var messageField: UITextView!
    @IBOutlet weak private var saveButton: UIBarButtonItem!
    private let dm = DataManager.shared
    private let utils = Utils.shared
    //Weitergegebene Variablen
    var editMode: Bool = false
    var contactDetail: Contact?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        utils.setTextViewBorder(textview: messageField)
        messageField.delegate = self
        initFields()
        if(editMode){
            nameField.text! = contactDetail!.name!
            statusField.text = contactDetail?.status
            emailField.text = contactDetail?.email
            phoneField.text = contactDetail?.phone
            messageField.text = contactDetail?.message
            if(contactDetail!.invite! == 1){
                inviteSwitch.setOn(true, animated: false)
            } else {
                inviteSwitch.setOn(false, animated: false)
            }
        }
        if(!dm.sessionAccount.isOwner){
            nameField.isEnabled = false
            statusField.isEnabled = false
            emailField.isEnabled = false
            phoneField.isEnabled = false
            inviteSwitch.isEnabled = false
            messageField.isEditable = false
            saveButton.isEnabled = false
            utils.setTextViewBackground(textview: messageField)
        }
    }
    
    /// Textfelder werden initalisiert
    private func initFields(){
        nameField.delegate = self
        statusField.delegate = self
        emailField.delegate = self
        emailField.tag = 1
        phoneField.delegate = self
        phoneField.tag = 1
    }
    

    
    /// Das Hinzufügen von Daten wird durch User abgebrochen
    /// - Parameter sender: Abbrechen Button
    @IBAction private func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// Fügt einen Kontakt hinzu
    /// - Parameter sender: add Button
    @IBAction private func addContactTapped(_ sender: Any) {
        if(nameField.text!.isEmpty){
            utils.showAltertCustom(sender: self, tilestr: "Kein Name", message: "Geben Sie einen Namen ein!", buttonText: "OK")
            return
        }
        var executed = false
        let inviteBoolNumber: NSNumber = inviteSwitch!.isOn as NSNumber
        let contact = Contact(name: nameField.text, status: statusField.text, email: emailField.text, phone: phoneField.text, invite: inviteBoolNumber, message: messageField.text, accountId: dm.sessionAccount.id)
        
        if(editMode){
            contact.id = contactDetail!.id!
            executed =  dm.updateContact(contact)
        } else {
         executed = dm.insertContact(contact)
        }
        if(executed){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    /// Return Button auf der Tastatur soll Tastatur ausblenden
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
    
    
    /// Schiebt die Ansicht nach oben, damit Tastatur das Eingabefeld nicht verdeckt
    /// - Parameter textField: Textfeld
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.tag == 1) {
             utils.moveView(y: -100, sender: self)
        }
    }
    
    /// Schiebt die Ansicht wieder in die Ausgangsposition
    /// - Parameter textField: Textfeld
    func textFieldDidEndEditing(_ textField: UITextField) {
       utils.moveView(y: 0, sender: self)
    }
    
    /// Schiebt die Ansicht nach oben, damit Tastatur das Eingabefeld nicht verdeckt
    /// - Parameter textView: Textview
    func textViewDidBeginEditing(_ textView: UITextView) {
        utils.moveView(y: -220, sender: self)
    }
    
    /// Schiebt die Ansicht wieder in die Ausgangsposition
    /// - Parameter textView: Textview
    func textViewDidEndEditing(_ textView: UITextView) {
         utils.moveView(y: 0, sender: self)
    }

}
