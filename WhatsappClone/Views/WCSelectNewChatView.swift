//
//  WCSelectNewChatView.swift
//  WhatsappClone
//
//  Created by MacOS on 19.03.2024.
//

import UIKit

protocol WCSelectNewChatViewDelegate: AnyObject {
    func didTapCell(_ tableView: UITableView, _ indexPath: IndexPath)
}

class WCSelectNewChatView: UIView {
    
    weak var delegate: WCSelectNewChatViewDelegate?

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(WCSelectNewChatTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        setUpConstraints()
        prepareTableView()
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

extension WCSelectNewChatView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! WCSelectNewChatTableViewCell
        var count = 0
        for index in 0..<indexPath.section {
            count += WCContactsManagment.shared.lettersCounts[index]
        }
        cell.configure(index: indexPath.row + count,flag: 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WCContactsManagment.shared.lettersCounts[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = UIScreen.main.bounds.height / 11
        return height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print(WCContactsManagment.shared.letters.count)
        return WCContactsManagment.shared.letters.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return WCContactsManagment.shared.letters[section]
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        let indexPath = IndexPath(row: 0, section: index)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        return index
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return WCContactsManagment.shared.letters
    }
    
    
}

extension WCSelectNewChatView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didTapCell(tableView, indexPath)
    }
}
