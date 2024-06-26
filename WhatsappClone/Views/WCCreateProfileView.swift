//
//  WCCreateProfileView.swift
//  WhatsappClone
//
//  Created by MacOS on 26.12.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol WCCreateProfileViewDelegate: AnyObject {
    func imageTapped()
    func didFinishCreatingProfile()
}

final class WCCreateProfileView: UIView {
    
    weak var delegate: WCCreateProfileViewDelegate?
    let viewModel:WCCreateProfileViewViewModel = WCCreateProfileViewViewModel()

    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "select-image2")
        imageView.layer.cornerRadius = 125
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let profileName: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "Enter your name"
        textfield.font = .systemFont(ofSize: 25)
        textfield.layer.cornerRadius = 10
        textfield.layer.borderWidth = 0.5
        textfield.layer.borderColor = UIColor.secondaryLabel.cgColor
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        textfield.leftView = paddingView
        textfield.leftViewMode = .always
        return textfield
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(profileImage,profileName)
        setUpConstraints()
        addActionToImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("unSupported!")
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            profileImage.heightAnchor.constraint(equalToConstant: 250),
            profileImage.widthAnchor.constraint(equalToConstant: 250),
            profileImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            profileName.leftAnchor.constraint(equalTo: leftAnchor, constant: 70),
            profileName.rightAnchor.constraint(equalTo: rightAnchor, constant: -70),
            profileName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 50)
        ])
    }
    
    private func addActionToImageView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        profileImage.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func handleTap() {
        delegate?.imageTapped()
    }
}

extension WCCreateProfileView: ImageSelectionDelegate {
    func didSelectImage(_ image: UIImage) {
        profileImage.image = image
    }
    
    func doneButtonTapped() {
        viewModel.saveNewUser(name: profileName.text ?? "", image: profileImage.image)
        self.delegate?.didFinishCreatingProfile()
    }
}
