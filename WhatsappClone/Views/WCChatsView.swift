//
//  WCChatsView.swift
//  WhatsappClone
//
//  Created by MacOS on 22.12.2023.
//

import UIKit
import FirebaseAuth
import Contacts
import Network


protocol WCChatsViewDelegate: AnyObject {
    func didSelectRow(conversation: WCConversation)
}

final class WCChatsView: UIView {
    
    var viewModel: WCChatsViewViewModel = WCChatsViewViewModel()
    var delegate: WCChatsViewDelegate?
    

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(WCChatsTableViewCell.self, forCellReuseIdentifier: "chatCell")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(tableView)
        setUpConstraints()
        prepareTableView()
        viewModel.subscribe { [weak self] bool in
            if bool {
                self?.tableView.reloadData()
            }
        }
        viewModel.getConversations()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("unSupported!")
    }
    
    private func prepareTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }

}

extension WCChatsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! WCChatsTableViewCell
        cell.configure(with: viewModel.cellViewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = UIScreen.main.bounds.height / 8
        return height
    }
}

extension WCChatsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(conversation: viewModel.getConversation(with: indexPath.row))
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
