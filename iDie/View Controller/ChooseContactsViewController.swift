//
//  HeritageChooseViewController.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl 
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import UIKit

class ChooseContactsViewController: UITableViewController {
    
    
    @IBOutlet private var contactTableView: UITableView!
    private let dm = DataManager.shared
    private let utils = Utils.shared
    private var contacts = [Contact]()
    private var choosedContacts = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    /// Lädt die Kontaktliste
    func loadData(){
        let data = dm.getAllContactsFromAccount()
        if(data.1){
            self.contacts = data.0
        }
        self.tableView.reloadData()
    }
    
    
    /// Ansicht wird geschlossen
    /// - Parameter sender: Abbrechen Button
    @IBAction private func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    /// Auswahl wird übernommen
    /// - Parameter sender: Auswählen Button
    @IBAction private func addTapped(_ sender: Any) {
        if(choosedContacts.isEmpty){
            utils.showAltertCustom(sender: self, tilestr: "Kein Kontakt", message: "Sie müssen min. einen Kontakt auswählen", buttonText: "OK")
            return
        }
        //Heritage
        if let destination = presentingViewController as? HeritageAddViewController {
            destination.choosedContacts = self.choosedContacts
            destination.shares = [String]()
            //String Array mit Platzhaltern füllen
            for _ in self.choosedContacts {
                destination.shares.append("")
            }
        }
        if let destination = presentingViewController as? AuthorityAddViewController {
            destination.choosedContacts = self.choosedContacts
            
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadChoosedList"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    //Zellen werden befüllt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactTableView.dequeueReusableCell(withIdentifier: "contactChooseCell", for: indexPath)
        let contact = contacts[indexPath.row]
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = contact.status
        return cell
    }
    
    //Haken wird gesetzt und Auswahl wird übernommen
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType != .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            choosedContacts.append(contacts[indexPath.row])
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            var i = 0
            for contact in choosedContacts {
                if(contact == contacts[indexPath.row]){
                    choosedContacts.remove(at: i)
                }
                 i = i + 1
            }
        }
    }
    
}
