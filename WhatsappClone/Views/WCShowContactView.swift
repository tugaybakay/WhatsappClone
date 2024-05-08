//
//  WCShowContactView.swift
//  WhatsappClone
//
//  Created by MacOS on 5.05.2024.
//

import UIKit

class WCShowContactView: UIView {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 25)
        return label
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        addSubviews(imageView,nameLabel,phoneLabel)
        setUPConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUPConstraints() {
        let width = UIScreen.main.bounds.width
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.heightAnchor.constraint(equalToConstant: width),
            
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            
            phoneLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            phoneLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10)
        ])
    }
    
    func configure(with contact: WCContact) {
        if let data = Data(base64Encoded: contact.image ?? ""), let image = UIImage(data: data) {
            imageView.image = image
        }
        nameLabel.text = contact.name
        phoneLabel.text = contact.phoneNumber
        
    }
}
