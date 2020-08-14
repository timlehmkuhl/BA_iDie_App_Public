//
//  OrganDonationViewController.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import UIKit

class OrganDonationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {

    @IBOutlet weak private var kindField: UITextField!
    @IBOutlet weak private var kindText: UITextView!
    @IBOutlet weak private var detailKindLabel: UILabel!
    @IBOutlet weak private var detailField: UITextView!
    @IBOutlet weak private var saveButton: UIBarButtonItem!
    
    private var picker = UIPickerView()
    private var choosedKind: String?
    private var choosedKindDetail: String?
    private let kinds = OrganDonation.kinds
    private let dm = DataManager.shared
    private let utils = Utils.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPicker()
        detailField.delegate = self
        utils.setTextViewBorder(textview: kindText)
        utils.setTextViewBorder(textview: detailField)
        loadData()
        if(!dm.sessionAccount.isOwner){
            saveButton.isEnabled = false
            kindField.isEnabled = false
            detailField.isEditable = false
            detailKindLabel.text = ""
            utils.setTextViewBackground(textview: kindText)
            utils.setTextViewBackground(textview: detailField)
        }
    }
    
    /// Lädt vorhandene Einträge
    private func loadData(){
        let existingData = dm.getOrganDonation()
        if(existingData.2 == false){
            utils.showLoadingFailureAlert(sender: self, viewGoback: true)
        }
        if(existingData.1 == true){
            kindField.text = existingData.0.kind
            kindText.text = existingData.0.kindDetail
            detailField.text = existingData.0.details
        }
    }
    
    
    /// Speichert oder ändert einen Eintrag
    /// - Parameter sender: Sichern Button
    @IBAction private func saveTapped(_ sender: Any) {
        let candidate = OrganDonation(kind: choosedKind, kindDetail: choosedKindDetail, details: detailField.text, accountid: dm.sessionAccount.id)
        let success = dm.insertOrUpdateOrganDonation(candidate)
        if(success){
            utils.showSuccesSaveAltert(sender: self)
        } else {
            utils.showFailedSaveAltert(sender: self)
        }
    }
    
    /// Initalisiert Picker als Auswahlmenü
    private func initPicker() {
         kindField.inputView = picker
         picker.delegate = self
         picker.dataSource = self
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
        detailKindLabel.text = kinds[row][2]
        choosedKind = kinds[row][0]
        choosedKindDetail = kinds[row][1]
        kindText.text = choosedKindDetail
        kindField.text = choosedKind
     }
     
    //Auswahlmöglichkeiten werden gesetzt
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return kinds[row][0]
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
        utils.moveView(y: -150, sender: self)
    }
    
    /// Schiebt die Ansicht wieder in die Ausgangsposition
    /// - Parameter textView: Textview
    func textViewDidEndEditing(_ textView: UITextView) {
         utils.moveView(y: 0, sender: self)
    }

}
