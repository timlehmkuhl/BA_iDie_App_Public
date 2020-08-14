//
//  AuthorityListViewController.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl on 14.05.20.
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import UIKit

class AuthorityListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak private var authorityTableView: UITableView!
    @IBOutlet weak private var addButton: UIBarButtonItem!
    
    private var authorities = [Authority]()
    private let dm = DataManager.shared
    private let utils = Utils.shared
    
    var isCellTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: "loadAuthorityList"), object: nil)
        
        authorityTableView.delegate = self
        authorityTableView.dataSource = self
        
        if(!dm.sessionAccount.isOwner){
            addButton.isEnabled = false
        }
    }
    
    /// Lädt vorhandene Daten
     @objc private func loadData(){
        let data = dm.getAllAuthority(withContacts: false)
        if(!data.2){
            utils.showLoadingFailureAlert(sender: self, viewGoback: true)
        }
        authorities = data.0
        self.authorityTableView.reloadData()
    }
    
    /// Öffnet Ansicht zur Eintragung von Daten
    /// - Parameter sender: Plus Button
    @IBAction private func addTapped(_ sender: Any) {
        performSegue(withIdentifier: "showAddAuthority", sender: self)
    }
    
    //Anzahl der Zellen
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authorities.count
    }
    
    //Zellen werden beschriftet
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = authorityTableView.dequeueReusableCell(withIdentifier: "authorityCell", for: indexPath)
        let authority = authorities[indexPath.row]
        var cellText = authority.kind
            
        if(authority.kind == "Sonstige" ){
            cellText = authority.infos
            }
        cell.textLabel?.text = cellText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       isCellTapped = true
        performSegue(withIdentifier: "showAddAuthority", sender: self)
    }
    
    //Löscht Banking Eintrag
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(!dm.sessionAccount.isOwner){
            return
        }
        if(editingStyle == .delete){
            let authorityToRemove = authorities[indexPath.row]
            let isDeleted = dm.deleteAuthority(authorityToRemove)
            if(isDeleted){
                authorities.remove(at: indexPath.row)
                authorityTableView.deleteRows(at: [indexPath], with: .bottom)
            }
        }
        
    }
    
    //Leitet Daten weiter
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(isCellTapped){ //because data should only passed when cell tapped
            if let destination = segue.destination as? AuthorityAddViewController {
                let authorityToPass = authorities[(authorityTableView.indexPathForSelectedRow?.row)!]
                destination.editMode = true
                    let contacts = dm.getContactsFromAuthority(authorityToPass)
                    if(contacts.1 == false){
                        utils.showLoadingFailureAlert(sender: self, viewGoback: false)
                    } else {
                        authorityToPass.contacts = contacts.0
                }
                destination.authorityDetail = authorityToPass
            
            }
            isCellTapped = false
       }
    }

}
