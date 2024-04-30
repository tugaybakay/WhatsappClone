//
//  WCChatWithView.swift
//  WhatsappClone
//
//  Created by MacOS on 4.04.2024.
//

import UIKit

class WCChatWithView: UIView {
    
    let wallpaper: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "wallpaper1")
        image.contentMode = .scaleAspectFill
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .brown
        addSubviews(wallpaper)
        translatesAutoresizingMaskIntoConstraints = false
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            wallpaper.topAnchor.constraint(equalTo: topAnchor),
            wallpaper.leftAnchor.constraint(equalTo: leftAnchor),
            wallpaper.rightAnchor.constraint(equalTo: rightAnchor),
            wallpaper.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}
