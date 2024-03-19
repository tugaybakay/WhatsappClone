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
        let cameraVC = WCCameraViewController()
        let settingsVC = WCSettingsViewController()
        let statusVC = WCStatusViewController()
        
        chatsVC.navigationItem.largeTitleDisplayMode = .automatic
        cameraVC.navigationItem.largeTitleDisplayMode  = .automatic
        settingsVC.navigationItem.largeTitleDisplayMode   = .automatic
        statusVC.navigationItem.largeTitleDisplayMode  = .automatic
        
        let nav1 = UINavigationController(rootViewController: statusVC)
        let nav2 = UINavigationController(rootViewController: chatsVC)
        let nav3 = UINavigationController(rootViewController: cameraVC)
        let nav4 = UINavigationController(rootViewController: settingsVC)
        
        nav1.tabBarItem = UITabBarItem(title: "Status", image: UIImage(systemName: "square.and.arrow.up"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "message"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Camera", image: UIImage(systemName: "camera"), tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 4)
        
        
        setViewControllers([nav1,nav2,nav3,nav4], animated: true)
    }

}

