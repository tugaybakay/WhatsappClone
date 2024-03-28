//
//  WCSearchContactsView.swift
//  WhatsappClone
//
//  Created by MacOS on 28.03.2024.
//

import UIKit

class WCSearchContactsView: UIView {

    
    let tableView: UITableView = {
        let tableView = UITableView()
//        tableView.backgroundColor = .black
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(WCSelectNewChatTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(tableView)
        prepareTableView()
        setUpConstraints()
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func prepareTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
}

extension WCSearchContactsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WCContactsManagment.shared.filteredContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WCSelectNewChatTableViewCell
        cell.configure(index: indexPath.row,flag: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = UIScreen.main.bounds.height / 11
        return height
    }
    
}

extension WCSearchContactsView: UITableViewDelegate {
    
}

