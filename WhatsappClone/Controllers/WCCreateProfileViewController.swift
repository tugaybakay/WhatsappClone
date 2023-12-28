//
//  WCCreateProfileViewController.swift
//  WhatsappClone
//
//  Created by MacOS on 26.12.2023.
//

import UIKit

protocol ImageSelectionDelegate: AnyObject {
    func didSelectImage(_ image: UIImage)
    func doneButtonTapped()
}

final class WCCreateProfileViewController: UIViewController {
    
    let createProfileView = WCCreateProfileView()
    weak var delegate: ImageSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = createProfileView
        createProfileView.delegate = self
        view.backgroundColor = .systemBackground
        view.addSubview(createProfileView)
        setUpConstraints()
        addDoneButtonItem()
        title = "create your profile"
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            createProfileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            createProfileView.leftAnchor.constraint(equalTo: view.leftAnchor),
            createProfileView.rightAnchor.constraint(equalTo: view.rightAnchor),
            createProfileView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func addDoneButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleTap))
    }
    
    @objc private func handleTap() {
        delegate?.doneButtonTapped()
    }
    
}

extension WCCreateProfileViewController: WCCreateProfileViewDelegate {
    func imageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true)
    }
    
    func didFinishCreatingProfile() {
        let destinationVC = WCTabBarController()
        destinationVC.modalPresentationStyle = .fullScreen
        self.present(destinationVC, animated: true)
    }
}

extension WCCreateProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            delegate?.didSelectImage(editedImage)
        }
//        if let originalImage = info[.originalImage] as? UIImage {
//            delegate?.didSelectImage(originalImage)
//        }
        picker.dismiss(animated: true)
    }
}
