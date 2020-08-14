//
//  ChurchViewController.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import UIKit

class ChurchViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak private var churchField: UITextField!
    @IBOutlet weak private var creedField: UITextField!
    @IBOutlet weak private var pastorField: UITextField!
    @IBOutlet weak private var psalmField: UITextField!
    @IBOutlet weak private var songsField: UITextView!
    @IBOutlet weak private var notesField: UITextView!
    @IBOutlet weak private var saveButton: UIBarButtonItem!
    
    private let dm = DataManager.shared
    private let utils = Utils.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadExistingData()
        utils.setTextViewBorder(textview: notesField)
        utils.setTextViewBorder(textview: songsField)
        churchField.delegate = self
        creedField.delegate = self
        psalmField.delegate = self
        psalmField.tag = 1
        pastorField.delegate = self
        pastorField.tag = 1
        songsField.delegate = self
        songsField.tag = 2
        notesField.delegate = self
        notesField.tag = 3
    }
    
    
    /// Lädt bereits vorhandene Eingaben
    private func loadExistingData(){
        let existingData = dm.getChurch()
        if(existingData.2 == false){
            utils.showLoadingFailureAlert(sender: self, viewGoback: true)
        }
        if(existingData.1 == true){
            churchField.text = existingData.0.church
            creedField.text = existingData.0.creed
            pastorField.text = existingData.0.pastor
            psalmField.text = existingData.0.psalm
            songsField.text = existingData.0.songs
            notesField.text = existingData.0.notes
        }
        
        if(!dm.sessionAccount.isOwner){
            psalmField.isEnabled = false
            churchField.isEnabled = false
            creedField.isEnabled = false
            pastorField.isEnabled = false
            songsField.isEditable = false
            notesField.isEditable = false
            saveButton.isEnabled = false
            utils.setTextViewBackground(textview: songsField)
            utils.setTextViewBackground(textview: notesField)
        }
    }
    
    
    /// Speichert oder ändert den Eintrag
    /// - Parameter sender: Sichern Button
    @IBAction private func saveTapped(_ sender: Any) {
        let candidate = Church(church: churchField.text, creed: creedField.text, pastor: pastorField.text, psalm: psalmField.text, songs: songsField.text, notes: notesField.text, accoundId: dm.sessionAccount.id)
        let success = dm.insertOrUpdateChurch(candidate)
        if(success){
            utils.showSuccesSaveAltert(sender: self)
        } else {
            utils.showFailedSaveAltert(sender: self)
        }
    }
    
    ///Ein touch außerhalb der Tastatur, lässt die Tastatur ausblenden
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
       if(textView.tag == 2){
            utils.moveView(y: -200, sender: self)
        }
        if(textView.tag == 3){
            utils.moveView(y: -250, sender: self)
        }
    }
    
    /// Schiebt die Ansicht wieder in die Ausgangsposition
    /// - Parameter textView: Textview
    func textViewDidEndEditing(_ textView: UITextView) {
         utils.moveView(y: 0, sender: self)
    }
    
    /// Return Button auf der Tastatur soll Tastatur ausblenden
    @IBAction private func returnPressed(_ sender: UITextField) {
          sender.resignFirstResponder()
      }

}
