//
//  WCShowContactViewController.swift
//  WhatsappClone
//
//  Created by MacOS on 5.05.2024.
//

import UIKit

class WCShowContactViewController: UIViewController {

    let showView = WCShowContactView()
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
        view.addSubview(showView)
        title = "Contact Info"
        setUpConstraints()
        showView.configure(with: contact)
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(backButtonDidTap))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = button
        
    }
    
    @objc func backButtonDidTap() {
        self.dismiss(animated: true)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            showView.topAnchor.constraint(equalTo: view.topAnchor),
            showView.leftAnchor.constraint(equalTo: view.leftAnchor),
            showView.rightAnchor.constraint(equalTo: view.rightAnchor),
            showView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }


}
