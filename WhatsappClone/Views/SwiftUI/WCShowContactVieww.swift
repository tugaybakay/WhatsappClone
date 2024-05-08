//
//  WCShowContactVieww.swift
//  WhatsappClone
//
//  Created by MacOS on 8.05.2024.
//

import SwiftUI

struct WCShowContactVieww: View {
    
    var name: String
    var phoneNumber: String
    var image: UIImage 
    
    
    init(name: String, phoneNumber: String,image: UIImage) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.image = image
    }
    
    var body: some View {
            //NavigationView {
                VStack {
                // Profil Resmi
                GeometryReader { geometry in
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
                        .clipped()
                        .clipShape(Circle())
                }
                .padding(.top,28)
                
                
                Label(name, systemImage: "person")
                    .padding(.top,-310)
                    
                
//                    .padding()
                
                // Telefon Numarası Alanı
                Label(phoneNumber, systemImage: "phone")
                    .padding(.top,-240)
                
                // Telefon Numarası Değer
                
//                    .padding()
                
                // Boşluk bırak
                Spacer()
            //}
//                .navigationBarTitle("Contact Info", displayMode: .inline)
//                .navigationBarItems(leading: backButton)
//            .padding()
                
            }
        }
    
    var backButton: some View {
            Button(action: {
                
            }) {
                HStack {
                    Image(systemName: "chevron.left") // Geri ok simgesi
                    Text("") // Geri metni
                }
            }
        }
    
    
}

struct WCShowContactVieww_Previews: PreviewProvider {
    static var previews: some View {
        WCShowContactVieww(name: "", phoneNumber: "", image: UIImage(systemName: "person")!)
    }
}
