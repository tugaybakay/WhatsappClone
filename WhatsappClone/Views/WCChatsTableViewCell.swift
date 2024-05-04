//
//  WCChatsTableViewCell.swift
//  WhatsappClone
//
//  Created by MacOS on 22.12.2023.
//

import UIKit

class WCChatsTableViewCell: UITableViewCell {
    
    let profileImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let contact = WCContactsManagment.shared.contacts.first
        imageView.backgroundColor = .black
        if let data = Data(base64Encoded: contact?.image ?? "", options: .ignoreUnknownCharacters){
            imageView.image = UIImage(data: data)
        }
        imageView.layer.cornerRadius = 37.5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Eyüp Gültekin"
        label.font = .boldSystemFont(ofSize: 19)
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "kanka squat yaparken dizim koptu, yardım!"
        label.numberOfLines = 2
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 15.5)
        
        
//        let imageAttachment = NSTextAttachment()
//        let image = UIImage(named: "double-tick")?.withRenderingMode(.alwaysTemplate)
//        imageAttachment.adjustsImageSizeForAccessibilityContentSizeCategory = true
//        imageAttachment.image = image?.withTintColor(.systemBlue)// Burada kendi ikonunuzun ismini verin
        
//        imageAttachment.bounds = CGRect(x: 0, y: -3, width: 18, height: 18)
//        let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: imageAttachment))
//        attributedString.append(textAfterImage)
//        label.attributedText = attributedString
//
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "13/10/2023"
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubviews(profileImage,nameLabel,messageLabel,dateLabel)
        setUpConstraints()
        self.accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = nil
        nameLabel.text = nil
        messageLabel.text = nil
        dateLabel.text = nil
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            profileImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            profileImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 75),
            profileImage.widthAnchor.constraint(equalToConstant: 75),
            
            nameLabel.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: 5),
            nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 15),
            nameLabel.heightAnchor.constraint(equalToConstant: profileImage.frame.height / 3),
            
            messageLabel.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor),
            messageLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            messageLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            
            dateLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            dateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20)
        ])
    }

    
    func configure(with conversation: WCConversation) {
        self.nameLabel.text = conversation.contact.name
        self.messageLabel.text = conversation.text
        if let data = Data(base64Encoded: conversation.contact.image ?? "", options: .ignoreUnknownCharacters) {
            self.profileImage.image = UIImage(data: data)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        let messageDate = conversation.date.dateValue()
        let messageDateString = dateFormatter.string(from: conversation.date.dateValue())
        
        let today = Date.now
        let distance = today.distance(to: conversation.date.dateValue())
        if distance > -86400 {
            dateLabel.text = "Today"
        }else if distance > -86400 * 2 {
            dateLabel.text = "Yesterday"
        }else {
            dateLabel.text = messageDateString
        }
    }
}
