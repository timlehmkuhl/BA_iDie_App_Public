//
//  HeritageListViewController.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl 
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import UIKit

class HeritageListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak private var heritagesTableView: UITableView!
    @IBOutlet weak private var addButton: UIBarButtonItem!
    
    private var heritages = [Heritage]()
    private var isCellTapped = false
    private let dm = DataManager.shared
    private let utils = Utils.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: "loadHeritageList"), object: nil)
        heritagesTableView.delegate = self
        heritagesTableView.dataSource = self
        loadData()
        if(!dm.sessionAccount.isOwner){
            addButton.isEnabled = false
        }
    }
    
    
    /// Lädt vorhandene Einträge
    @objc private func loadData(){
        let dataResponse = dm.getAllHeritages(withContacts: false)
        if(dataResponse.1 == false){
            self.utils.showLoadingFailureAlert(sender: self, viewGoback: true)
        }
        let data = dataResponse.0
        heritages = data
        self.heritagesTableView.reloadData()
    }
    
    
    /// Wechselt zur Eingabe Ansicht
    /// - Parameter sender: Plus Button
    @IBAction private func addTipped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showHeritageAdd", sender: self)
    }
    
    //Anzahl Zellen
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heritages.count
    }
    
    //Zellen werden beschriftet
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = heritagesTableView.dequeueReusableCell(withIdentifier: "heritageCell", for: indexPath)
        let heritage = heritages[indexPath.row]
        cell.textLabel?.text = heritage.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isCellTapped = true
         performSegue(withIdentifier: "showHeritageAdd", sender: self)
     }
    
    //Löscht Heritage
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(!dm.sessionAccount.isOwner){
            return
        }
        if(editingStyle == .delete){
            let heritageToRemove = heritages[indexPath.row]
            let isDeleted = dm.deleteHeritage(heritageToRemove)
            if(isDeleted){
                heritages.remove(at: indexPath.row)
                heritagesTableView.deleteRows(at: [indexPath], with: .bottom)
            }
        }
        
    }
    
    //Weiterleiten von Daten
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(isCellTapped){ //because data should only passed when cell tapped
            if let destination = segue.destination as? HeritageAddViewController {
                let heritageToPass = heritages[(heritagesTableView.indexPathForSelectedRow?.row)!]
                destination.editMode = true
                let contacts = dm.getContactsFromHeritage(heritageToPass)
                if(contacts.1 == false){
                    utils.showLoadingFailureAlert(sender: self, viewGoback: false)
                }
                heritageToPass.contacts = contacts.0
                heritageToPass.shares = dm.getSharesFromHeritage(heritageToPass)
                destination.heritgeDetail = heritageToPass
            }
            isCellTapped = false
       }
    }
    
}
