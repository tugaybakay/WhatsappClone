//
//  WCSettingsOption.swift
//  WhatsappClone
//
//  Created by MacOS on 4.05.2024.
//

import UIKit

enum WCSettingsOption: CaseIterable {
    case rateApp
    case terms
    case privacycase
    case viewCode
    case firabaseReference
    case logout
    
    var targetURL: URL? {
        switch self {
        case .rateApp:
            return nil
        case .terms:
            return URL(string: "https://www.whatsapp.com/legal/terms-of-service")
        case .privacycase:
            return URL(string: "https://www.whatsapp.com/privacy")
        case .viewCode:
            return URL(string: "https://www.github.com/tugaybakay")
        case .firabaseReference:
            return URL(string: "https://firebase.google.com/docs")
        case .logout:
            return nil
        }
    }
    
    var displayTitle: String {
        switch self {
        case .rateApp:
            return "Rate App"
        case .terms:
            return "Terms of Service"
        case .privacycase:
            return "Privacy Policy"
        case .viewCode:
            return "View App Code"
        case .firabaseReference:
            return "Firebase Documentations"
        case .logout:
            return "Logout"
        }
    }
    
    var iconContainerColor: UIColor {
        switch self {
        case .rateApp:
            return UIColor.systemBlue
        case .terms:
            return UIColor.systemOrange
        case .privacycase:
            return UIColor.systemYellow
        case .viewCode:
            return UIColor.systemGreen
        case .firabaseReference:
            return UIColor.systemPink
        case .logout:
            return UIColor.red
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .terms:
            return UIImage(systemName: "doc")
        case .privacycase:
            return UIImage(systemName: "lock")
        case .viewCode:
            return UIImage(systemName: "hammer.fill")
        case .firabaseReference:
            return UIImage(systemName: "list.clipboard")
        case .logout:
            return UIImage(systemName: "rectangle.portrait.and.arrow.forward")
        }
    }
}
