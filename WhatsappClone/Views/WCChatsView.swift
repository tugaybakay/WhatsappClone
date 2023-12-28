//
//  WCChatsView.swift
//  WhatsappClone
//
//  Created by MacOS on 22.12.2023.
//

import UIKit

final class WCChatsView: UIView {
    
    var viewModel: WCChatsViewViewModel?

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
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = UIScreen.main.bounds.height / 8
        return height
    }
}

extension WCChatsView: UITableViewDelegate {
    
}
