//
//  HeritageViewController.swift
//  iDie
//
//  Created by Tim Michael Lehmkuhl 
//  Copyright © 2020 Tim Michael Lehmkuhl. All rights reserved.
//

import UIKit

class HeritageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Wechselt zur Social Media Ansicht
    /// - Parameter sender: Social Media Button
    @IBAction private func socialMediaTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "showSocialMedia", sender: self)
    }
    
    /// Wechselt zur Online Account Ansicht
    /// - Parameter sender: Social Media Button
    @IBAction private func showOnlineAccounts(_ sender: Any) {
        self.performSegue(withIdentifier: "showOnlineAccounts", sender: self)
    }
    
    /// Wechselt zur Erb Ansicht
    /// - Parameter sender: Social Media Button
    @IBAction private func heritageTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "showHeritageList", sender: self)
    }
    
    /// Gibt dem OnlineAccountListViewController an, ob der online Account oder Social Media Button gedrückt wurde
    /// - Parameters:
    ///   - segue: segue
    ///   - sender:  online Account oder Social Media Button
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showSocialMedia"){
            if let destination = segue.destination as? OnlineAccountListViewController {
                destination.isSocialMediaView = true
            }
        }
        if(segue.identifier == "showOnlineAccounts"){
            if let destination = segue.destination as? OnlineAccountListViewController {
                destination.isSocialMediaView = false
            }
        }
    }
    
}
