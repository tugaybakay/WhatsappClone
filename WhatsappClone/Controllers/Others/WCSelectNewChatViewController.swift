//
//  WCSelectNewChatViewController.swift
//  WhatsappClone
//
//  Created by MacOS on 19.03.2024.
//

import UIKit

class WCSelectNewChatViewController: UIViewController {

    let chatView = WCSelectNewChatView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubviews(chatView)
        setUpConstraints()
        title = "Test"
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            chatView.topAnchor.constraint(equalTo: view.topAnchor),
            chatView.leftAnchor.constraint(equalTo: view.leftAnchor),
            chatView.rightAnchor.constraint(equalTo: view.rightAnchor),
            chatView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

extension WCSelectNewChatViewController: WCSelectNewChatViewDelegate {
    func didTapCell(_ tableView: UITableView, _ indexPath: IndexPath) {
        // SEGUE
    }
}
