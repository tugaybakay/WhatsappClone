//
//  WCWelcomeViewController.swift
//  WhatsappClone
//
//  Created by MacOS on 8.12.2023.
//

import UIKit

class WCWelcomeViewController: UIViewController {
    
    private let welcomeView = WCWelcomeView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        navigationController?.isNavigationBarHidden = true
        
    }

}
