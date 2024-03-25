//
//  WCSelectNewChatTableViewCell.swift
//  WhatsappClone
//
//  Created by MacOS on 19.03.2024.
//

import UIKit

class WCSelectNewChatTableViewCell: UITableViewCell {
    
    let profileImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubviews(profileImage,nameLabel)
        setUpConstraints()
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            profileImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            profileImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 60),
            profileImage.widthAnchor.constraint(equalToConstant: 60),
            
            nameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 20)
        ])
    }
    
    func configure(index: Int) {
        let contact = WCContactsManagment.shared.contacts[index]
        nameLabel.text = contact.name
        profileImage.backgroundColor = .black
        if let data = Data(base64Encoded: contact.image ?? "", options: .ignoreUnknownCharacters){
            profileImage.image = UIImage(data: data)
        }
    }

}
