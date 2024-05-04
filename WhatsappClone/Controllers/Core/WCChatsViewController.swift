//
//  WCChatsViewController.swift
//  WhatsappClone
//
//  Created by MacOS on 7.12.2023.
//

import UIKit

class WCChatsViewController: UIViewController {
    
    let chatView = WCChatsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(chatView)
        chatView.delegate = self
        setUpConstraints()
        title = "Chats"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .done, target: self, action: #selector(buttonDidTap))
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            chatView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chatView.leftAnchor.constraint(equalTo: view.leftAnchor),
            chatView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            chatView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    @objc private func buttonDidTap() {
        let vc = UINavigationController(rootViewController: WCSelectNewChatViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

}

extension WCChatsViewController: WCChatsViewDelegate {
    func didSelectRow(conversation: WCConversation) {
        let destinationVC = WCChatWithViewController(user: conversation.contact,roomid: conversation.roomid)
        let navbar = UINavigationController(rootViewController: destinationVC)
        navbar.modalPresentationStyle = .fullScreen
        self.present(navbar, animated: true)
    }
}
