//
//  FuneralCelebrationViewController.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import UIKit

class FuneralFeastViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak private var locationField: UITextField!
    @IBOutlet weak private var foodField: UITextView!
    @IBOutlet weak private var notesField: UITextView!
    @IBOutlet weak private var saveButton: UIBarButtonItem!
    private let dm = DataManager.shared
    private let utils = Utils.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadExistingData()
        utils.setTextViewBorder(textview: notesField)
        utils.setTextViewBorder(textview: foodField)
        foodField.delegate = self
        foodField.tag = 1
        notesField.delegate = self
        notesField.tag = 2
    }
    
    /// Lädt bereits vorhandene Eingaben
    private func loadExistingData(){
        let existingData = dm.getFuneralFeast()
        if(existingData.2 == false){
            utils.showLoadingFailureAlert(sender: self, viewGoback: true)
        }
        if(existingData.1 == true){
            locationField.text = existingData.0.location
             foodField.text = existingData.0.food
            notesField.text = existingData.0.notes
        }
        
        if(!dm.sessionAccount.isOwner){
            locationField.isEnabled = false
            foodField.isEditable = false
            notesField.isEditable = false
            saveButton.isEnabled = false
            utils.setTextViewBackground(textview: foodField)
            utils.setTextViewBackground(textview: notesField)
        }
    }
    
    /// Speichert oder ändert einen Eintrag
    /// - Parameter sender: Sichern Button
    @IBAction private func saveTapped(_ sender: Any) {
        let candidate = FuneralFeast(location: locationField.text, food: foodField.text, notes: notesField.text, accoundId: dm.sessionAccount.id)
        let success = dm.insertOrUpdateFuneralFeast(candidate)
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
    /// - Parameter textView: Textview
    func textViewDidBeginEditing(_ textView: UITextView) {
       if(textView.tag == 1){
            utils.moveView(y: -100, sender: self)
        }
        if(textView.tag == 2){
            utils.moveView(y: -220, sender: self)
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
