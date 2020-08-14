//
//  HeritageAddViewController.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl 
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import UIKit

class HeritageAddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak private var addButton: UIBarButtonItem!
    @IBOutlet weak private var nameField: UITextField!
    @IBOutlet weak private var choosedContactsTableView: UITableView!
    @IBOutlet weak private var addContactsButton: UIButton!
    @IBOutlet weak private var featuresField: UITextView!
    
    private let dm = DataManager.shared
    private let utils = Utils.shared
    
    //Weitergegebene Variablen
    var choosedContacts = [Contact]()
    var shares = [String]()
    var editMode: Bool = false
    var heritgeDetail: Heritage?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        featuresField.delegate = self
        choosedContactsTableView.delegate = self
        choosedContactsTableView.dataSource = self
        utils.setTextViewBorder(textview: featuresField)
        NotificationCenter.default.addObserver(self, selector: #selector(loadChoosedList), name: NSNotification.Name(rawValue: "loadChoosedList"), object: nil)
        if(editMode){
            nameField.text! = heritgeDetail!.name!
            featuresField.text! = heritgeDetail!.features!
            choosedContacts = heritgeDetail!.contacts!
            shares = heritgeDetail!.shares!
        }
        if(!dm.sessionAccount.isOwner){
            nameField.isEnabled = false
            featuresField.isEditable = false
            addContactsButton.isEnabled = false
            addButton.isEnabled = false
            utils.setTextViewBackground(textview: featuresField)
        }
    }
    
    
    /// Lädt die Kontaktliste neu
    /// - Parameter notification: NSNotification
    @objc private func loadChoosedList(notification: NSNotification){
        DispatchQueue.main.async {
            self.choosedContactsTableView.reloadData()
        }
    }
    
    
    /// Öffnet das Fenster um Kontakte auszuwählen
    /// - Parameter sender: Choose Button
    @IBAction private func chooseTapped(_ sender: Any) {
        let contacts = dm.getAllContactsFromAccount()
        if contacts.0.isEmpty {
            utils.showMissingContactsAltert(sender: self)
            return
        }
        performSegue(withIdentifier: "showContactChooser", sender: self)
    }
    
    
    /// Fügt ein neuen Erbgegenstand hinzu oder ändert einen Vorhanden
    /// - Parameter sender: Add Button
    @IBAction private func addTapped(_ sender: Any) {
        if(nameField.text!.isEmpty){
            utils.showMissingInputAlert(sender: self, missing: "Bezeichnung")
            return
        }
        var executed = false
        let heritage = Heritage(name: nameField.text!, features: featuresField.text!, aid: dm.sessionAccount.id!, contacts: choosedContacts, shares: self.shares)
        if(editMode){
            heritage.id = heritgeDetail!.id
            executed = dm.updateHeritageWithoutContacts(heritage)
        } else {
            executed = dm.insertHeritage(heritage)
        }
        
        if(executed){
            dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadHeritageList"), object: nil)})
        } else {
            utils.showFailedSaveAltert(sender: self)
        }
    }
    
    
    /// Schließt das Fenster bei Abbruch
    /// - Parameter sender:Abbrechen Button
    @IBAction private func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /// Schließt die Tastatur bei der return Taste
    /// - Parameter sender: Textfeld
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
    
    //Anzahl der Zellen
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choosedContacts.count
    }
    
    //Zellen werden beschriftet
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = choosedContactsTableView.dequeueReusableCell(withIdentifier: "choosedContactsList", for: indexPath) as! HeritageContactTableViewCell
        let contact = choosedContacts[indexPath.row]
        cell.shareField.delegate = self
        if(!dm.sessionAccount.isOwner){
            cell.shareField.isEnabled = false
        }
        cell.nameLabel.text! = contact.name!
        if(editMode){
            cell.shareField.text! = shares[indexPath.row]
        }
        cell.shareField.tag = indexPath.row
        return cell
    }
    
    
    /// Schiebt die Ansicht in Ausgangsposition und setzt Anteil Wert
    /// - Parameter textField: Textfeld
    func textFieldDidEndEditing(_ textField: UITextField) {
        let index = IndexPath(row: textField.tag, section: 0).row
        if(index < shares.count){
            shares[index] = textField.text!
        }
        utils.moveView(y: 0, sender: self)
    }
    
    
    /// Schiebt die Ansicht nach oben, damit Tastatur das Eingabefeld nicht verdeckt
    /// - Parameter textField: Textfeld
    func textFieldDidBeginEditing(_ textField: UITextField) {
        utils.moveView(y: -250, sender: self)
    }
    
    
    /// Schiebt die Ansicht nach oben, damit Tastatur das Eingabefeld nicht verdeckt
    /// - Parameter textView: Textview
    func textViewDidBeginEditing(_ textView: UITextView) {
         utils.moveView(y: -100, sender: self)
    }
    
    /// Schiebt die Ansicht wieder in die Ausgangsposition
    /// - Parameter textView: Textview
    func textViewDidEndEditing(_ textView: UITextView) {
         utils.moveView(y: 0, sender: self)
    }
    
   
    
}
