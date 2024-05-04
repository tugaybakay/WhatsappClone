//
//  WCSettingsView.swift
//  WhatsappClone
//
//  Created by MacOS on 4.05.2024.
//

import SwiftUI

struct WCSettingsView: View {
    let viewModel: WCSettingsViewViewModel
    
    init(viewModel: WCSettingsViewViewModel) {
        self.viewModel = viewModel
    }
    
    
    
    var body: some View {
        List(viewModel.cellViewModels) { viewModel in
            HStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20,height: 20)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color(uiColor: viewModel.iconContainerColor))
                        .cornerRadius(8)
                }
                Text(viewModel.title)
                    .padding(.leading, 10)
                Spacer()
            }
            .padding(.bottom, 10)
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.onTapHandler(viewModel.type)
            }
            
        }
        
    }
}

struct WCSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        WCSettingsView(viewModel: .init(cellViewModels: WCSettingsOption.allCases.compactMap({
            return WCSettingsCellViewModel(type: $0) { _ in
                
            }
        })))
    }
}
