//
//  SettingsViewController.swift
//  VK
//
//  Created by Дмитрий Супрун on 14.06.22.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userDefaults.bool(forKey: "darkMode") {
            darkModeSwitch.isOn = true
        } else {
            darkModeSwitch.isOn = false
        }
        
    }
    
    @IBAction func switchDarkMode(_ sender: UISwitch) {
        userDefaults.setValue(sender.isOn, forKey: "darkMode")
        view.window?.overrideUserInterfaceStyle = userDefaults.bool(forKey: "darkMode") ? .dark : .light
    }
}
