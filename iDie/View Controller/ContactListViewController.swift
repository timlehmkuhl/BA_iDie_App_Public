//
//  ContactListViewController.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl 
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import UIKit

class ContactListViewController: UITableViewController {

    @IBOutlet weak private var addButton: UIBarButtonItem!
    @IBOutlet private var contactTableView: UITableView!
    
    private var contacts = [Contact]()
    private var isAddPressed = false
    private let dm = DataManager.shared
    private let utils = Utils.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: "load"), object: nil)
        loadData()
        if(!dm.sessionAccount.isOwner){
            addButton.isEnabled = false
        }
    }
    
    
    /// Lädt vorhandene Einträge
    @objc private func loadData(){
        let data = dm.getAllContactsFromAccount()
        if(data.1){
            self.contacts = data.0
        } else {
            self.title = "Keine Verbindung!"
            utils.showLoadingFailureAlert(sender: self, viewGoback: false)
        }
        self.tableView.reloadData()
        isAddPressed = false
    }
    
    
    /// Setzt nach Verbindungsfehler wieder den korrekte Title
    override func viewDidDisappear(_ animated: Bool) {
         self.title = "Kontakte"
    }
    
    
    /// Öffnet Ansicht zum hinzufügen oder ändern eines Kontakts
    /// - Parameter sender: Plus Button
    @IBAction private func goToAddContact(_ sender: Any) {
        isAddPressed = true
        performSegue(withIdentifier: "showAddContact", sender: self)
    }
    
    //Anzahl Zellen
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    //Zellen werden beschriftet
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactTableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        let contact = contacts[indexPath.row]
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = contact.status
        return cell
    }
    
    //Zelle wird getippt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showAddContact", sender: self)
    }
    
    //Löscht Contact
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(!dm.sessionAccount.isOwner){
            return
        }
        if(editingStyle == .delete){
            let contactToRemove = contacts[indexPath.row]
            let isDeleted = dm.deleteContact(contactToRemove)
            if(isDeleted){
                contacts.remove(at: indexPath.row)
                contactTableView.deleteRows(at: [indexPath], with: .bottom)
            } else {    //Es bestehen verknüpfungen zu Erbgegenständen oder Vollmachten
                var isDeletedWithReferences = false
                let alert = UIAlertController(title: "Verknüpfungen", message: "Der Kontakt ist  mit Erbgegenständen oder Vollmachten verknüpft. Der Kontakt wird dort ebenfalls gelöscht. Sind Sie einverstanden?", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    self.dm.deleteReferencesFromContact(contactToRemove)
                    isDeletedWithReferences = self.dm.deleteContact(contactToRemove)
                    self.contacts.remove(at: indexPath.row)
                    self.contactTableView.deleteRows(at: [indexPath], with: .bottom)
                }))
                alert.addAction(UIAlertAction(title: "Abbrechen", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                if(!isDeletedWithReferences){
                    utils.showFailedSaveAltert(sender: self)
                }
            }
        }
    }
    
    //Daten werden weitergeleitet
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(!isAddPressed){
            if let destination = segue.destination as? ContactAddViewController {
                destination.editMode = true
                destination.contactDetail = contacts[(contactTableView.indexPathForSelectedRow?.row)!]
            }
            isAddPressed = false
        }
    }
    

}
