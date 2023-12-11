//
//  WCRegisterView.swift
//  WhatsappClone
//
//  Created by MacOS on 11.12.2023.
//

import UIKit

class WCRegisterView: UIView {
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "Please confirm your country code and enter your phone number"
        return label
    }()
    
    let countryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Turkey"
        label.font = .systemFont(ofSize: 32)
        label.textColor = .systemBlue
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let countryNameButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(">", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 28)
        button.setTitleColor(.lightGray, for: .normal)
        return button
    }()
    
    let topSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    let bottomSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    let countryCodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32)
        label.text = "+90"
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "phone number"
        textField.font = .systemFont(ofSize: 32)
        textField.sizeToFit()
        return textField
    }()
    
    let bottom2SeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    let btwSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(infoLabel,countryNameLabel,countryNameButton,topSeparatorView,bottomSeparatorView,countryCodeLabel,phoneNumberTextField,bottom2SeparatorView,btwSeparatorView)
        setUpConstraints()
        prepareLabelUserInteraction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("unSupported!")
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            infoLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 50),
            infoLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -50),
            infoLabel.heightAnchor.constraint(equalToConstant: 100),
            
            countryNameLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 15),
            countryNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            countryNameLabel.rightAnchor.constraint(equalTo: countryNameButton.leftAnchor),
            
            topSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            topSeparatorView.bottomAnchor.constraint(equalTo: countryNameLabel.topAnchor, constant: -10),
            topSeparatorView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20),
            topSeparatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            bottomSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            bottomSeparatorView.topAnchor.constraint(equalTo: countryNameLabel.bottomAnchor, constant: 10),
            bottomSeparatorView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20),
            bottomSeparatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            countryNameButton.heightAnchor.constraint(equalTo: countryNameLabel.heightAnchor),
            countryNameButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -25),
            countryNameButton.widthAnchor.constraint(equalTo: countryNameLabel.widthAnchor, multiplier: 0.1),
            countryNameButton.centerYAnchor.constraint(equalTo: countryNameLabel.centerYAnchor),
            
            countryCodeLabel.topAnchor.constraint(equalTo: bottomSeparatorView.bottomAnchor, constant: 2),
            countryCodeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            countryCodeLabel.heightAnchor.constraint(equalTo: countryNameLabel.heightAnchor, multiplier: 2),
            countryCodeLabel.widthAnchor.constraint(equalTo: countryNameLabel.widthAnchor, multiplier: 0.27),
            
            phoneNumberTextField.topAnchor.constraint(equalTo: countryCodeLabel.topAnchor),
            phoneNumberTextField.heightAnchor.constraint(equalTo: countryNameLabel.heightAnchor, multiplier: 2),
            phoneNumberTextField.leftAnchor.constraint(equalTo: countryCodeLabel.rightAnchor, constant: 10),
            phoneNumberTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -25),
            
            bottom2SeparatorView.heightAnchor.constraint(equalToConstant: 1),
            bottom2SeparatorView.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 0),
            bottom2SeparatorView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20),
            bottom2SeparatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            btwSeparatorView.heightAnchor.constraint(equalTo: countryCodeLabel.heightAnchor, constant: -2),
            btwSeparatorView.widthAnchor.constraint(equalToConstant: 1),
            btwSeparatorView.centerYAnchor.constraint(equalTo: countryCodeLabel.centerYAnchor),
            btwSeparatorView.leftAnchor.constraint(equalTo: countryCodeLabel.rightAnchor)
            
        ])
    }
    
    private func prepareLabelUserInteraction() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(countryLabelTapped))
        countryNameLabel.addGestureRecognizer(tapGestureRecognizer)
        countryNameButton.addTarget(self, action: #selector(countryLabelTapped), for: .touchUpInside)
    }
    
    @objc private func countryLabelTapped() {
        print("ok")
    }
}
