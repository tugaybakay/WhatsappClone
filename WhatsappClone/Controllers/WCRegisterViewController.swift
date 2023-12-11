//
//  WCRegisterViewController.swift
//  WhatsappClone
//
//  Created by MacOS on 8.12.2023.
//

import UIKit

class WCRegisterViewController: UIViewController {
    
    let registerView = WCRegisterView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(registerView)
        prepareNavBar()
        setUpConstraints()
        prepareDoneButtonItem()
    }
    
    private func prepareNavBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.lightText
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]

        navigationController?.navigationBar.tintColor = .systemBlue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

//        navigationItem.hidesBackButton = false
        navigationController?.navigationBar.barTintColor = .gray
        title = "Phone number"
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            registerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            registerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            registerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            registerView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func prepareDoneButtonItem() {
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleTap))
        navigationItem.rightBarButtonItem = doneButton
        doneButton.isEnabled = false
    }
    
    @objc private func handleTap() {
        print("ok")
    }


}
