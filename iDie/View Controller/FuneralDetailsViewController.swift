//
//  FuneralDetailsViewController.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import UIKit

class FuneralDetailsViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak private var companyField: UITextField!
    @IBOutlet weak private var locationField: UITextField!
    @IBOutlet weak private var speakerField: UITextField!
    @IBOutlet weak private var speechField: UITextView!
    @IBOutlet weak private var songsField: UITextView!
    @IBOutlet weak private var notesField: UITextView!
    @IBOutlet weak private var saveButton: UIBarButtonItem!
    
    private let dm = DataManager.shared
    private let utils = Utils.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songsField.delegate = self
        speechField.tag = 1
        notesField.delegate = self
        speechField.delegate = self
        loadExistingData()
        utils.setTextViewBorder(textview: speechField)
        utils.setTextViewBorder(textview: songsField)
        utils.setTextViewBorder(textview: notesField)

    }
    
    
    /// Lädt bereits getätige Eingaben
    private func loadExistingData(){
        let existingData = dm.getFuneral()
        if(existingData.2 == false){
            utils.showLoadingFailureAlert(sender: self, viewGoback: true)
        }
        if(existingData.1 == true){
            companyField.text = existingData.0.company
            locationField.text = existingData.0.location
            speakerField.text = existingData.0.speeker
            speechField.text = existingData.0.speech
            songsField.text = existingData.0.songs
            notesField.text = existingData.0.notes
        }
        
        if(!dm.sessionAccount.isOwner){
            saveButton.isEnabled = false
            companyField.isEnabled = false
            locationField.isEnabled = false
            speakerField.isEnabled = false
            speechField.isEditable = false
            songsField.isEditable = false
            notesField.isEditable = false
            utils.setTextViewBackground(textview: speechField)
            utils.setTextViewBackground(textview: songsField)
            utils.setTextViewBackground(textview: notesField)
        }
    }
    
    
    
    /// Speichert oder ändert die getätigten Eingaben
    /// - Parameter sender: Speichern Button
    @IBAction private func saveTapped(_ sender: Any) {
        let candidate = Funeral(company: companyField.text, location: locationField.text, songs: songsField.text, speeker: speakerField.text, speech: speechField.text, notes: notesField.text, accountId: dm.sessionAccount.id)
        let success = dm.insertOrUpdateFuneral(candidate)
        if(success){
            utils.showSuccesSaveAltert(sender: self)
        } else {
            utils.showFailedSaveAltert(sender: self)
        }
    }
    

    ///  Ein touch außerhalb der Tastatur, lässt die Tastatur ausblenden
    /// - Parameters:
    ///   - touches: touch
    ///   - event: event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    /// Schiebt die Ansicht nach oben, damit Tastatur das Eingabefeld nicht verdeckt
    /// - Parameter textView: Textview
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.tag == 1){
          utils.moveView(y: -100, sender: self)
        } else {
            utils.moveView(y: -200, sender: self)
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
