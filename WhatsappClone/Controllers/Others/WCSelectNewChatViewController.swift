//
//  WCSelectNewChatViewController.swift
//  WhatsappClone
//
//  Created by MacOS on 19.03.2024.
//

import UIKit

class WCSelectNewChatViewController: UIViewController {
    
    let chatView = WCSelectNewChatView()
    let searchView = WCSearchContactsView()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubviews(searchView,chatView,searchBar)
        setUpConstraints()
        title = "New Chat"
        chatView.delegate = self
        searchBar.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "x.circle"), style: .done, target: self, action: #selector(barButtonDidTap))
    }
    
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            searchView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            searchView.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            chatView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            chatView.leftAnchor.constraint(equalTo: view.leftAnchor),
            chatView.rightAnchor.constraint(equalTo: view.rightAnchor),
            chatView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func barButtonDidTap() {
        self.dismiss(animated: true)
    }
    
    
}


extension WCSelectNewChatViewController: WCSelectNewChatViewDelegate {
    func didTapCell(contact: WCContact) {
        let vc = WCChatWithViewController(user: contact)
//        vc.title = contact.name.uppercased()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WCSelectNewChatViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchView.isHidden = true
            chatView.isHidden = false
        }else {
            WCContactsManagment.shared.filteredContacts = WCContactsManagment.shared.contacts.filter({
                if $0.name.contains(searchText) {
                    return true
                }
                return false
            })
            DispatchQueue.main.async {
                self.searchView.tableView.reloadData()
            }
            searchView.isHidden = false
            chatView.isHidden = true
        }
    }
}

