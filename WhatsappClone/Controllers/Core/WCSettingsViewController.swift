//
//  WCSettingsViewController.swift
//  WhatsappClone
//
//  Created by MacOS on 7.12.2023.
//

import UIKit
import SwiftUI
import SafariServices
import StoreKit
import FirebaseAuth

class WCSettingsViewController: UIViewController {
    
    private var settingsSwiftUIController: UIHostingController<WCSettingsView>?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        addSwiftUIController()
    }
    
    private func addSwiftUIController() {
        
        let settingsSwiftUIController = UIHostingController(rootView: WCSettingsView(viewModel: WCSettingsViewViewModel(cellViewModels: WCSettingsOption.allCases.compactMap({
            return WCSettingsCellViewModel(type: $0) { [weak self] option in
                self?.handleTap(option: option)
            }
        }))))
        
        addChild(settingsSwiftUIController)
        settingsSwiftUIController.didMove(toParent: self)
        view.addSubview(settingsSwiftUIController.view)
        settingsSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsSwiftUIController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsSwiftUIController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            settingsSwiftUIController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            settingsSwiftUIController.view.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        self.settingsSwiftUIController = settingsSwiftUIController
    }
    
    private func handleTap(option: WCSettingsOption) {
        guard Thread.current.isMainThread else {return}
        if let url = option.targetURL {
            let vc = SFSafariViewController(url: url)
            present(vc,animated: true)
        }else if option == .rateApp {
            if let windowScene = view.window?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }else if option == .logout {
            let alert = UIAlertController(title: "Logout!", message: "Oturumu sonlandırmak istediğinize emin misiniz?", preferredStyle: .alert)
            let action = UIAlertAction(title: "Yes", style: .default) { _ in
                do {
                    try Auth.auth().signOut()
                    let vc = UINavigationController(rootViewController: WCWelcomeViewController())
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }catch {
                    print(error.localizedDescription)
                }
            }
            
            alert.addAction(action)
            alert.addAction(.init(title: "Cancel", style: .destructive))
            
            present(alert, animated: true)
        }
        
    }

}
