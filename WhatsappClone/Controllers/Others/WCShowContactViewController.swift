//
//  WCShowContactViewController.swift
//  WhatsappClone
//
//  Created by MacOS on 5.05.2024.
//

import SwiftUI
import UIKit

class WCShowContactViewController: UIViewController {

    private var showContactSwiftUIController: UIHostingController<WCShowContactVieww>?
//    let showView = WCShowContactView()
    var contact: WCContact!
    
    init(contact: WCContact) {
        self.contact = contact
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.addSubview(showView)
        addSwiftUIController()
        title = "Contact Info"
//        setUpConstraints()
//        showView.configure(with: contact)
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(backButtonDidTap))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = button
        
        
    }
    
    private func addSwiftUIController() {
        var contactImage: UIImage!
        if let data = Data(base64Encoded: contact.image ?? "", options: .ignoreUnknownCharacters), let image = UIImage(data: data) {
            contactImage = image
        }else {
            contactImage = UIImage(systemName: "person")!
        }
        
        let showContactSwiftUIController = UIHostingController(rootView: WCShowContactVieww(name: contact.name, phoneNumber: contact.phoneNumber, image: contactImage))
        
        addChild(showContactSwiftUIController)
        showContactSwiftUIController.didMove(toParent: self)
        view.addSubview(showContactSwiftUIController.view)
        showContactSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            showContactSwiftUIController.view.topAnchor.constraint(equalTo: view.topAnchor),
            showContactSwiftUIController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            showContactSwiftUIController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            showContactSwiftUIController.view.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        self.showContactSwiftUIController = showContactSwiftUIController
    }
    
    @objc func backButtonDidTap() {
        self.dismiss(animated: true)
    }
    
//    private func setUpConstraints() {
//        NSLayoutConstraint.activate([
//            showView.topAnchor.constraint(equalTo: view.topAnchor),
//            showView.leftAnchor.constraint(equalTo: view.leftAnchor),
//            showView.rightAnchor.constraint(equalTo: view.rightAnchor),
//            showView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }


}
