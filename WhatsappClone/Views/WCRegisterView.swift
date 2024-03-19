//
//  WCRegisterView.swift
//  WhatsappClone
//
//  Created by MacOS on 11.12.2023.
//

import UIKit
import CountryPickerView


protocol WCRegisterViewDelegate: AnyObject {
    func wcRegisterView(didTap pickerView: CountryPickerView)
}

class WCRegisterView: UIView {
    
    weak var delegate: WCRegisterViewDelegate?
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "Please confirm your country code and enter your phone number"
        return label
    }()
    
    let countryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "United Stated"
        label.font = .systemFont(ofSize: 23)
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
    
    let countryPickerView: CountryPickerView = {
        let pickerView = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
//        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "phone number"
        textField.font = .systemFont(ofSize: 22)
        
        textField.sizeToFit()
        return textField
    }()
    
    let bottom2SeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(infoLabel,countryNameLabel,countryNameButton,topSeparatorView,bottomSeparatorView,phoneNumberTextField,bottom2SeparatorView)
        setUpConstraints()
        prepareLabelUserInteraction()
 
        phoneNumberTextField.leftView = countryPickerView
        phoneNumberTextField.leftViewMode = .always
        phoneNumberTextField.leftView?.bounds.origin.x += 5
        countryPickerView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("unSupported!")
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            infoLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 35),
            infoLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -35),
            infoLabel.heightAnchor.constraint(equalToConstant: 100),
            
            countryNameLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 10),
            countryNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            countryNameLabel.rightAnchor.constraint(equalTo: countryNameButton.leftAnchor),
//            countryNameLabel.heightAnchor.constraint(equalToConstant: 100),
            
            topSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            topSeparatorView.bottomAnchor.constraint(equalTo: countryNameLabel.topAnchor, constant: -5),
            topSeparatorView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20),
            topSeparatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            bottomSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            bottomSeparatorView.topAnchor.constraint(equalTo: countryNameLabel.bottomAnchor, constant: 5),
            bottomSeparatorView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20),
            bottomSeparatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            countryNameButton.heightAnchor.constraint(equalTo: countryNameLabel.heightAnchor),
            countryNameButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -25),
            countryNameButton.widthAnchor.constraint(equalTo: countryNameLabel.widthAnchor, multiplier: 0.1),
            countryNameButton.centerYAnchor.constraint(equalTo: countryNameLabel.centerYAnchor),
            
            phoneNumberTextField.topAnchor.constraint(equalTo: bottomSeparatorView.bottomAnchor, constant: 2),
            phoneNumberTextField.heightAnchor.constraint(equalTo: countryNameLabel.heightAnchor, multiplier: 1.35),
            phoneNumberTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            phoneNumberTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -25),
            
            bottom2SeparatorView.heightAnchor.constraint(equalToConstant: 1),
            bottom2SeparatorView.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 0),
            bottom2SeparatorView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20),
            bottom2SeparatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
        ])
    }
    
    private func prepareLabelUserInteraction() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(countryLabelTapped))
        countryNameLabel.addGestureRecognizer(tapGestureRecognizer)
        countryNameButton.addTarget(self, action: #selector(countryLabelTapped), for: .touchUpInside)
    }
    
    @objc private func countryLabelTapped() {
        delegate?.wcRegisterView(didTap: countryPickerView)
    }
    
    private func popUpPickerView() {
        let pickerView = CountryPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pickerView)
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: topAnchor),
            pickerView.leftAnchor.constraint(equalTo: leftAnchor),
            pickerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            pickerView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    func getNumber() -> String? {
        if phoneNumberTextField.text != "" {
            return countryPickerView.selectedCountry.phoneCode + phoneNumberTextField.text!
        }
        return nil
    }
}


extension WCRegisterView: CountryPickerViewDelegate, CountryPickerViewDataSource {
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        countryNameLabel.text = country.name
    }
    
    
}


