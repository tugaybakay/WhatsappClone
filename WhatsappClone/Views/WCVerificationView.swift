//
//  WCVerificationView.swift
//  WhatsappClone
//
//  Created by MacOS on 12.12.2023.
//

import UIKit
import KKPinCodeTextField

protocol WCVerificationViewDelegate: AnyObject {
    func textDidChange(code: String)
}

final class WCVerificationView: UIView {

    let explanationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "To complete your phone number verification, please enter the 6-digit activition code"
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let verificationCodeTextField: KKPinCodeTextField = {
        let textfield = KKPinCodeTextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.digitsCount = 6
        textfield.emptyDigitBorderColor = .lightGray
        textfield.keyboardType = .numberPad
        textfield.font = .boldSystemFont(ofSize: 25)
        textfield.textAlignment = .center
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        addSubviews(explanationLabel,verificationCodeTextField)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("unSupported!")
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            explanationLabel.topAnchor.constraint(equalTo: topAnchor,constant: 30),
            explanationLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            explanationLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
//            explanationLabel.heightAnchor.constraint(equalToConstant: 200),
            
            verificationCodeTextField.topAnchor.constraint(equalTo: explanationLabel.bottomAnchor, constant: 30),
            verificationCodeTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 60),
            verificationCodeTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -60)
//            verificationCodeTextField.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func getText() -> String {
        if let code = verificationCodeTextField.text {
            return code
        }
        return ""
    }

}

