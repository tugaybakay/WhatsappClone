//
//  WCWelcomeView.swift
//  WhatsappClone
//
//  Created by MacOS on 8.12.2023.
//

import UIKit
import SafariServices

class WCWelcomeView: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "wp-icon")
        return imageView
    }()
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 32)
        label.text = "Welcome to Whatsapp"
        return label
    }()

    let privacyTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isSelectable = true
//        textView.dataDetectorTypes = .link
        let attributedString = NSMutableAttributedString(string: "  Read our Privacy Policy, Tap \"Agree & Continue \" to accept the Terms of Service")
//        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttributes([.foregroundColor: UIColor.red,.font: UIFont.systemFont(ofSize: 17)], range: NSRange(location: 0, length: attributedString.length))
        let privacyPolicyRange = attributedString.mutableString.range(of: "Privacy Policy")
        attributedString.addAttribute(.link, value: "https://www.whatsapp.com/legal/privacy-policy", range: privacyPolicyRange)
        let termsOfServiceRange = attributedString.mutableString.range(of: "Terms of Service")
        attributedString.addAttribute(.link, value: "https://www.whatsapp.com/legal/terms-of-service", range: termsOfServiceRange)
        textView.attributedText = attributedString
        return textView
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedString = NSMutableAttributedString(string: "Agree & Continue")
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 23), range: NSRange(location: 0, length: attributedString.length))
        button.setAttributedTitle(attributedString, for: .normal)
//        button.setTitle("Agree & Continue", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    let whatsappLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        label.text = "WhatsApp from tugaybakay"
        label.textColor = .tertiaryLabel
//        label.backgroundColor = .red
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(imageView,welcomeLabel,privacyTextView,button,whatsappLabel)
        backgroundColor = .systemBackground
        setUpConstraints()
        customizeTextColor()
        
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }
    
    @objc func handleTap() {
        print("deneme")
    }
    
    required init?(coder: NSCoder) {
        fatalError("unSupported!")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        customizeTextColor()
    }
    
    private func customizeTextColor() {
        let userInterfaceStyle = traitCollection.userInterfaceStyle
        switch userInterfaceStyle {
        case .light, .unspecified:
            privacyTextView.textColor = .black
        case .dark:
            privacyTextView.textColor = .white
        @unknown default:
            fatalError()
        }
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100),
            imageView.leftAnchor.constraint(equalTo: leftAnchor,constant: 60),
            imageView.rightAnchor.constraint(equalTo: rightAnchor,constant: -60),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            welcomeLabel.bottomAnchor.constraint(equalTo: privacyTextView.topAnchor, constant: -25),
            welcomeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            welcomeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -30),
            
//            privacyTextView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 50),
            privacyTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 45),
            privacyTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -45),
            privacyTextView.heightAnchor.constraint(equalToConstant: 100),
            privacyTextView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -50),

            button.bottomAnchor.constraint(equalTo: whatsappLabel.topAnchor, constant: -50),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            whatsappLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -15),
            whatsappLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 50),
            whatsappLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -50),
            whatsappLabel.heightAnchor.constraint(equalToConstant: 70)
            
            
//            button.leftAnchor.constraint(equalTo: leftAnchor,constant: 50),
//            button.rightAnchor.constraint(equalTo: rightAnchor,constant: -50)
        ])
    }
}
