//
//  ViewController.swift
//  WhatsappClone
//
//  Created by MacOS on 7.12.2023.
//

import UIKit
import FirebaseAuth

class WCTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpTabBars()
        WCContactsManagment.shared.fetchAllContactsLocal()
    }

    private func setUpTabBars() {
        let chatsVC = WCChatsViewController()
        let settingsVC = WCSettingsViewController()
        
        chatsVC.navigationItem.largeTitleDisplayMode = .automatic
        settingsVC.navigationItem.largeTitleDisplayMode   = .automatic
        
        let nav2 = UINavigationController(rootViewController: chatsVC)
        let nav4 = UINavigationController(rootViewController: settingsVC)
        
        nav2.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "message"), tag: 1)
        nav4.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)
        
        
        setViewControllers([nav2,nav4], animated: true)
    }

}

