//
//  FuneralKindViewController.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import UIKit

class FuneralKindViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {

    @IBOutlet weak private var generalKindField: UITextField!
    @IBOutlet weak private var detailKindField: UITextField!
    @IBOutlet weak private var infoLabel: UILabel!
    @IBOutlet weak private var kindNotesField: UITextView!
    @IBOutlet weak private var saveButton: UIBarButtonItem!
    @IBOutlet weak private var detailField: UITextView!
    
    private var pickerGeneral = UIPickerView()
    private var pickerDetail = UIPickerView()
    private let kinds = Funeral.kinds
    private let kindKeyDetails = Funeral.kindKeyDetails
    private let kindCustom = Funeral.custom
    private var choosedGeneralKind: String?
    private var choosedDetailKind: String?
    private let dm = DataManager.shared
    private let utils = Utils.shared
    private var detailText: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailField.delegate = self
        kindNotesField.delegate = self
        initPickers()
        loadExistingData()
        utils.setTextViewBorder(textview: kindNotesField)
        kindNotesField.tag = 3
        utils.setTextViewBorder(textview: detailField)
        
    }
    
    
    /// Bereits vorhandene Daten werden geladen
    private func loadExistingData(){
        let existingData = dm.getFuneral()
        if(existingData.2 == false){
            utils.showLoadingFailureAlert(sender: self, viewGoback: true)
        }
        if(existingData.1 == true){
            choosedGeneralKind = existingData.0.kind
            choosedDetailKind = existingData.0.kindDetails
            generalKindField.text = choosedGeneralKind
            detailKindField.text = choosedDetailKind
            detailField.text = existingData.0.kindInfos
            kindNotesField.text = existingData.0.kindNotes
            if(detailKindField.text == kindCustom){
                detailField.isEditable = true
            } else {
                detailField.isEditable = false
            }
        }
        
        if(!dm.sessionAccount.isOwner){
            saveButton.isEnabled = false
            generalKindField.isEnabled = false
            detailKindField.isEnabled = false
            detailField.isEditable = false
            kindNotesField.isEditable = false
            utils.setTextViewBackground(textview: kindNotesField)
            utils.setTextViewBackground(textview: detailField)
        }
    }
    
    
    /// Initalisiert Picker als Auswahlmenü
    private func initPickers() {
        generalKindField.inputView = pickerGeneral
        pickerGeneral.delegate = self
        pickerGeneral.dataSource = self
        let pickerToolBar = UIToolbar()
        pickerToolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Fertig", style: .plain, target: self, action: #selector(donePickerTapped))
        pickerToolBar.setItems([doneButton], animated: false)
        generalKindField.inputAccessoryView = pickerToolBar
        pickerGeneral.tag = 1
        
        detailKindField.inputView = pickerDetail
        pickerDetail.delegate = self
        pickerDetail.dataSource = self
        detailKindField.inputAccessoryView = pickerToolBar
        pickerDetail.tag = 2
    }
    
    /// Schließt Picker
    @objc private func donePickerTapped() {
        generalKindField.resignFirstResponder()
        detailKindField.resignFirstResponder()
    }
    
    /// Speichert oder ändert einen Eintrag
    /// - Parameter sender: Sichern Button
    @IBAction private func saveTapped(_ sender: Any) {
        let candidate = Funeral()
        candidate.accountId = dm.sessionAccount.id
        candidate.kind = choosedGeneralKind
        candidate.kindDetails = choosedDetailKind
        candidate.kindInfos = detailField.text
        candidate.kindNotes = kindNotesField.text
        let success = dm.insertOrUpdateFuneral(candidate)
        if(success){
            utils.showSuccesSaveAltert(sender: self)
        } else {
            utils.showFailedSaveAltert(sender: self)
        }
    }
    
    //Anzahl der zu treffenden Auswahl
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
    }
     
    //Anzahl der Auswahlmöglichkeiten
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1) {
            return kinds.count
        } else {
            return kinds[choosedGeneralKind!]?.count ?? 0
        }
    }
     
    //Auswahl wird übernommen
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 1) {
            choosedGeneralKind = Array(kinds.keys)[row]
            choosedDetailKind = ""
            generalKindField.text = choosedGeneralKind
            detailText = kindKeyDetails[choosedGeneralKind!]
            detailField.text = (choosedGeneralKind! + ":\n" + detailText!)
            detailKindField.text = ""
            
        } else {
            let array = Array(kinds[choosedGeneralKind!]?.keys ?? ["":""].keys)
            choosedDetailKind = array[row]
            detailKindField.text = choosedDetailKind
            if(choosedDetailKind == kindCustom){
                detailField.isEditable = true
            } else {
                detailField.isEditable = false
            }
            let arrayWithDicts = kinds[choosedGeneralKind!]
            detailText = kindKeyDetails[choosedGeneralKind!]
            for dict in arrayWithDicts!{
                if(dict.key == choosedDetailKind){
                    detailField.text = (choosedGeneralKind! + ":\n" + detailText! + "\n\n" + choosedDetailKind! + "\n" + dict.value)
                }
            }
        }
        
    }
     
    //Auswahlmöglichkeiten werden gesetzt
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1) {
        return Array(kinds.keys)[row]
        } else {
            let array = Array(kinds[choosedGeneralKind!]?.keys ?? ["":""].keys)
            return array[row]
        }
       
    }
    
    /// Schiebt die Ansicht nach oben, damit Tastatur das Eingabefeld nicht verdeckt
    /// - Parameter textView: Textview
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(kindNotesField.tag != 3){
            utils.moveView(y: -150, sender: self)
        } else {
            utils.moveView(y: -250, sender: self)
        }
        
    }
    
    /// Schiebt die Ansicht wieder in die Ausgangsposition
    /// - Parameter textView: Textview
    func textViewDidEndEditing(_ textView: UITextView) {
        utils.moveView(y: 0, sender: self)
    }
    
    
    /// Ein touch außerhalb der Tastatur, lässt die Tastatur ausblenden
    /// - Parameters:
    ///   - touches: touch
    ///   - event: event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    

}
