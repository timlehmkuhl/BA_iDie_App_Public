//
//  SocialMediaListViewController.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl on 07.04.20.
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import UIKit

class OnlineAccountListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak private var onlineAccountTableView: UITableView!
    @IBOutlet weak private var addButton: UIBarButtonItem!
    private let dm = DataManager.shared
    private let utils = Utils.shared
    private var onlineAccounts = [OnlineAccount]()
    
    private var isCellTapped = false
    //Weitergegebene Variablen
    var isSocialMediaView: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: "loadSocialMediaList"), object: nil)
        
        onlineAccountTableView.delegate = self
        onlineAccountTableView.dataSource = self
        
        if(!dm.sessionAccount.isOwner){
            addButton.isEnabled = false
        }
        loadData()
    }
    
    
    /// Lädt vorhandene Einträge
    @objc private func loadData(){
        if(isSocialMediaView!){
            let data = dm.getAllOnlineAccounts(isSocialMedia: true)
            if(data.1 == false) {
                utils.showLoadingFailureAlert(sender: self, viewGoback: true)
            } else {
                onlineAccounts = data.0
            }
        } else {
            let data = dm.getAllOnlineAccounts(isSocialMedia: false)
            if(data.1 == false) {
                utils.showLoadingFailureAlert(sender: self, viewGoback: true)
            } else {
                onlineAccounts = data.0
            }
        }
        self.onlineAccountTableView.reloadData()
    }
    
    
    
    /// Wechselt zur Eingabe-Ansicht
    /// - Parameter sender: Plus Button
    @IBAction private func addTapped(_ sender: Any) {
        performSegue(withIdentifier: "showSocialMediaAdd", sender: self)
    }
    
    //Anzahl der Zellen
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return onlineAccounts.count
    }
    
    //Zellen werden ausgefüllt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = onlineAccountTableView.dequeueReusableCell(withIdentifier: "socialMediaCell", for: indexPath)
        let onlineAccount = onlineAccounts[indexPath.row]
        cell.textLabel?.text = onlineAccount.platform
        if(isSocialMediaView!){
            cell.detailTextLabel?.text = onlineAccount.nickname
        } else {
            cell.detailTextLabel?.text = onlineAccount.email
        }
        return cell
    }
    
    //Tipp auf Zelle
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isCellTapped = true
        performSegue(withIdentifier: "showSocialMediaAdd", sender: self)
    }
    
    //Löscht SocialMedia
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(!dm.sessionAccount.isOwner){
            return
        }
        if(editingStyle == .delete){
            let onlineAccountToRemove = onlineAccounts[indexPath.row]
            let isDeleted = dm.deleteOnlineAccount(onlineAccountToRemove)
            if(isDeleted){
                onlineAccounts.remove(at: indexPath.row)
                onlineAccountTableView.deleteRows(at: [indexPath], with: .bottom)
            }
        }
        
    }
    
    //Weiterleitung von Daten
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? OnlineAccountAddViewController {
            destination.isSocialMedia = self.isSocialMediaView
        }
        if(isCellTapped){ //because data should only passed when cell tapped
            if let destination = segue.destination as? OnlineAccountAddViewController {
                let socialMediaToPass = onlineAccounts[(onlineAccountTableView.indexPathForSelectedRow?.row)!]
                destination.editMode = true
                destination.onlineAccountDetail = socialMediaToPass
                destination.isSocialMedia = self.isSocialMediaView
            }
            isCellTapped = false
        }
    }
    
}
