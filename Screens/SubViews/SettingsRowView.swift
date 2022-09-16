//
//  SettingsRowView.swift
//  CatGram
//
//  Created by Estefania Cano Robles on 10/09/22.
//

import SwiftUI

struct SettingsRowView: View {
    
    var leftIcon: String
    var text: String
    var color: Color
    
    var body: some View {
        
        HStack {
            
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(color)
                
                
                Image(systemName: leftIcon)
            }
            .frame(width: 36, height: 36, alignment: .center)
            .font(.title3)
            .foregroundColor(.white)
            
            
            Text(text)
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
    }
}

struct SettingsRowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRowView(leftIcon: "heart.fill", text: "Row title", color: .red)
            .previewLayout(.sizeThatFits)
    }
}
