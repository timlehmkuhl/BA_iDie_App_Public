//
//  AuthorityViewController.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import UIKit

class AuthorityAddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource,  UITextViewDelegate  {
    

    @IBOutlet weak private var informationLabel: UILabel!
    @IBOutlet weak private var kindField: UITextField!
    @IBOutlet weak private var informationField: UITextView!
    @IBOutlet weak private var notesField: UITextView!
    @IBOutlet weak private var contactTableView: UITableView!
    @IBOutlet weak private var saveButton: UIBarButtonItem!
    @IBOutlet weak private var chooseButton: UIButton!
    
    private let dm = DataManager.shared
    private let utils = Utils.shared
    private let kinds = Authority.kinds
    private var kindPicker = UIPickerView()
    
    //Weitergegebene Variablen
    var editMode: Bool = false
    var authorityDetail: Authority?
    var choosedContacts = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPicker()
        contactTableView.delegate = self
        contactTableView.dataSource = self
        notesField.delegate = self
        informationField.isEditable = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadContactList), name: NSNotification.Name(rawValue: "loadChoosedList"), object: nil)
        
        utils.setTextViewBorder(textview: notesField)
        utils.setTextViewBorder(textview: informationField)
        
        if(editMode){
            kindField.text = authorityDetail?.kind
            informationField.text = authorityDetail?.infos
            notesField.text = authorityDetail?.notes
            choosedContacts = authorityDetail!.contacts!
           if(kindField.text! == "Sonstige" ){
               informationLabel.text = "Art angeben:"
               informationField.isEditable = true
           }
        }
        
        if(!dm.sessionAccount.isOwner){
            kindField.isEnabled = false
            informationField.isEditable = false
            notesField.isEditable = false
            saveButton.isEnabled = false
            chooseButton.isEnabled = false
            utils.setTextViewBackground(textview: informationField)
            utils.setTextViewBackground(textview: notesField)
        }
    }
    
    
    /// Lädt Kontaktliste
    /// - Parameter notification: Notification
    @objc private func loadContactList(notification: NSNotification){
        self.contactTableView.reloadData()
    }
    
    /// Initalisiert Picker als Auswahlmenü
    private func initPicker() {
        kindField.inputView = kindPicker
        kindPicker.delegate = self
        kindPicker.dataSource = self
        let pickerToolBar = UIToolbar()
        pickerToolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Fertig", style: .plain, target: self, action: #selector(donePickerTapped))
        pickerToolBar.setItems([doneButton], animated: false)
        kindField.inputAccessoryView = pickerToolBar
    }
    
    /// Schließt Picker
    @objc private func donePickerTapped() {
        kindField.resignFirstResponder()
    }
    
    
    /// Speichert oder ändert einen Eintrag
    /// - Parameter sender: Sichern Button
    @IBAction private func saveTapped(_ sender: Any) {
        if(kindField.text!.isEmpty){
            utils.showMissingInputAlert(sender: self, missing: "Vollmacht-Art")
            return
        }
        var executed = false
         let authority = Authority(kind: kindField.text, infos: informationField.text, notes: notesField.text, contacts: nil, accountID: dm.sessionAccount.id)
        authority.contacts = choosedContacts
         if(editMode){
             authority.id = authorityDetail!.id
            executed = dm.updateAuthorityWithContacts(authority)
            dump(executed)
         } else {
             executed = dm.insertAuthority(authority: authority)
         }
         if(executed){
             dismiss(animated: true, completion: {
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadAuthorityList"), object: nil)})
         } else {
             utils.showFailedSaveAltert(sender: self)
         }
    }
    
    
    /// Öffnet Ansicht zur Kontaktauswahl
    /// - Parameter sender: Kontakt Plus Symbol
    @IBAction private func addContactsTapped(_ sender: Any) {
        let contacts = dm.getAllContactsFromAccount()
        if contacts.0.isEmpty {
            utils.showMissingContactsAltert(sender: self)
            return
        }
        performSegue(withIdentifier: "showContactListFromAuthority", sender: self)
    }
    
    /// Das Hinzufügen von Daten wird durch User abgebrochen
    /// - Parameter sender: Abbrechen Button
    @IBAction private func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /// Ein touch außerhalb der Tastatur, lässt die Tastatur ausblenden
    /// - Parameters:
    ///   - touches: touch
    ///   - event: event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //Anzahl der Zellen
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return choosedContacts.count
    }
    
    //Zellen werden beschriftet
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactTableView.dequeueReusableCell(withIdentifier: "contactAuthorityCell", for: indexPath)
        let contact = choosedContacts[indexPath.row]
        cell.textLabel?.text = contact.name
        return cell
    }
    
    /// Schiebt die Ansicht nach oben, damit Tastatur das Eingabefeld nicht verdeckt
    /// - Parameter textView: Textview
    func textViewDidBeginEditing(_ textView: UITextView) {
        utils.moveView(y: -150, sender: self)
    }
    
    /// Schiebt die Ansicht wieder in die Ausgangsposition
    /// - Parameter textView: Textview
    func textViewDidEndEditing(_ textView: UITextView) {
         utils.moveView(y: 0, sender: self)
    }
    
    //Anzahl der zu treffenden Auswahl
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Anzahl der Auswahlmöglichkeiten
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return kinds.count
    }
    
    //Auswahl wird übernommen
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        kindField.text = Array(kinds.keys)[row]
        if(kindField.text! == "Sonstige" ){
            informationLabel.text = "Art angeben:"
            informationField.text = ""
            informationField.isEditable = true
        } else {
            informationLabel.text = "Informationen zur Art:"
            informationField.text = Array(kinds.values)[row]
            informationField.isEditable = false
        }
    }
    
    //Auswahlmöglichkeiten werden gesetzt
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        Array(kinds.keys)[row]
    }

}
