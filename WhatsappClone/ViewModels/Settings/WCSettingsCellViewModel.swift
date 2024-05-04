//
//  WCSettingsCellViewModel.swift
//  WhatsappClone
//
//  Created by MacOS on 4.05.2024.
//

import UIKit

struct WCSettingsCellViewModel: Identifiable {
    let id = UUID()
    let type: WCSettingsOption
    
    var image: UIImage? {
        return type.iconImage
    }
    
    var iconContainerColor: UIColor {
        return type.iconContainerColor
    }
    
    var title: String {
        return type.displayTitle
    }
    
    let onTapHandler: (WCSettingsOption) -> Void
    
    init(type: WCSettingsOption, onTapHandler: @escaping (WCSettingsOption) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }
    
}
