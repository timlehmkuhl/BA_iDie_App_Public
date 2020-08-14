//
//  BankingAddViewController.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl 
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import UIKit

class BankingAddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {

    @IBOutlet weak private var bankField: UITextField!
    @IBOutlet weak private var kindField: UITextField!
    @IBOutlet weak private var ibanField: UITextField!
    @IBOutlet weak private var bicField: UITextField!
    @IBOutlet weak private var balanceField: UITextField!
    @IBOutlet weak private var notesField: UITextView!
    @IBOutlet weak private var addButton: UIBarButtonItem!
    @IBOutlet weak private var navigationBar: UINavigationBar!
    
    private var picker = UIPickerView()
    private let kinds = Banking.kinds
    private let dm = DataManager.shared
    private let utils = Utils.shared
    
    //Weitergegebene Variablen
    var editMode: Bool = false
    var bankingDetail: Banking?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.topItem!.title = "Konto"
        initPicker()
        utils.setTextViewBorder(textview: notesField)
        notesField.delegate = self
        if(editMode){
            bankField.text! = bankingDetail!.bank!
            kindField.text! = bankingDetail!.kind!
            ibanField.text? = bankingDetail!.iban!
            bicField.text? = bankingDetail!.bic!
            balanceField.text = bankingDetail?.balance?.stringValue.replacingOccurrences(of: ".", with: ",") ?? ""
            if(balanceField.text == "-1"){
                balanceField.text = ""
            }
            notesField.text? = bankingDetail!.notes!
        }
        if(!dm.sessionAccount.isOwner){
            bankField.isEnabled = false
            kindField.isEnabled = false
            ibanField.isEnabled = false
            bicField.isEnabled = false
            balanceField.isEnabled = false
            notesField.isEditable = false
            addButton.isEnabled = false
            utils.setTextViewBackground(textview: notesField)
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
    
    
    /// Lässt Picker verschinden
    @objc private func donePickerTapped() {
        kindField.resignFirstResponder()
    }
    
    /// Schiebt die Ansicht nach oben, damit Tastatur das Eingabefeld nicht verdeckt
    /// - Parameter textView: Textview
    func textViewDidBeginEditing(_ textView: UITextView) {
        utils.moveView(y: -222, sender: self)
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
        kindField.text = kinds[row]
    }
    
    //Auswahlmöglichkeiten werden gesetzt
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return kinds[row]
    }
    
    
    
    /// Speichert oder ändert einen Bank Eintrag
    /// - Parameter sender: Sichern Button
    @IBAction private func saveTapped(_ sender: Any) {
        if(bankField.text!.isEmpty || kindField.text!.isEmpty){
            utils.showMissingInputAlert(sender: self, missing: "Bank und Kontoart")
            return
        }
        var executed = false
        let banking = Banking(bank: bankField.text!, kind: kindField.text!, iban: ibanField.text, bic: bicField.text, balance: -1, notes: notesField.text, accoundID: dm.sessionAccount.id!)
        if(!balanceField.text!.isEmpty){
          banking.balance = NSNumber.init(value: Double(balanceField.text!.replacingOccurrences(of: ",", with: "."))!)
        }
        if(editMode){
            banking.id = bankingDetail!.id
            executed = dm.updateBanking(banking)
        } else {
            executed = dm.insertBanking(banking)
        }
        if(executed){
            dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadBankingList"), object: nil)})
        } else {
            utils.showFailedSaveAltert(sender: self)
        }
    }
    
    /// Ein touch außerhalb der Tastatur, lässt die Tastatur ausblenden
    /// - Parameters:
    ///   - touches: touch
    ///   - event: event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    /// Schließt die Ansicht
    /// - Parameter sender: Abbrechen Button
    @IBAction private func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /// Return Button auf der Tastatur soll Tastatur ausblenden
    @IBAction private func returnPressed(_ sender: UITextField) {
          sender.resignFirstResponder()
      }
    

}
