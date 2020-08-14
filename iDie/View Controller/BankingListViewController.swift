//
//  BankingListViewController.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl 
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import UIKit

class BankingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak private var bankingTableView: UITableView!
    @IBOutlet weak private var addButton: UIBarButtonItem!
    
    private var bankings = [Banking]()
    private var isCellTapped = false
    
    private let dm = DataManager.shared
    private let utils = Utils.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: "loadBankingList"), object: nil)
        bankingTableView.delegate = self
        bankingTableView.dataSource = self
        if(!dm.sessionAccount.isOwner){
            addButton.isEnabled = false
        }
    }
    
    
    /// Lädt vorhandene Einträge
    @objc private func loadData(){
        let data = dm.getAllBanking()
        if(data.1 == false){
            utils.showLoadingFailureAlert(sender: self, viewGoback: true)
        } else {
            bankings = data.0
            self.bankingTableView.reloadData()
        }
    }
    
    /// Wechselt zur Eingabe Ansicht
    /// - Parameter sender: Plus Button
    @IBAction private func addTapped(_ sender: Any) {
        performSegue(withIdentifier: "showBankingAdd", sender: self)
    }
    
    //Anzahl Zellen
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bankings.count
    }
    
    //Zellen werden beschriftet
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bankingTableView.dequeueReusableCell(withIdentifier: "bankingCell", for: indexPath)
        let banking = bankings[indexPath.row]
        cell.textLabel?.text = banking.bank
        cell.detailTextLabel?.text = banking.kind
        return cell
    }
    
    //Zelle wird getippt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         isCellTapped = true
         performSegue(withIdentifier: "showBankingAdd", sender: self)
     }
    
    //Löscht Banking Eintrag
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(!dm.sessionAccount.isOwner){
            return
        }
        if(editingStyle == .delete){
            let bankingToRemove = bankings[indexPath.row]
            let isDeleted = dm.deleteBanking(bankingToRemove)
            if(isDeleted){
                bankings.remove(at: indexPath.row)
                bankingTableView.deleteRows(at: [indexPath], with: .bottom)
            }
        }
    }
    
    //Weiterleiten von Daten
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(isCellTapped){ //Daten sollen nur bei Zellen-Tapp weitergegeben werden
            if let destination = segue.destination as? BankingAddViewController {
                let bankingToPass = bankings[(bankingTableView.indexPathForSelectedRow?.row)!]
                destination.editMode = true
                destination.bankingDetail = bankingToPass
            }
            isCellTapped = false
       }
    }

}
