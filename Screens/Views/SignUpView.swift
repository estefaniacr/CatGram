//
//  SignUpView.swift
//  CatGram
//
//  Created by Estefania Cano Robles on 10/09/22.
//

import SwiftUI

struct SignUpView: View {
    
    @State var showOnbboarding: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            
            Spacer()
            
            Image("logo.transparent")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
            
            Text("You're not signed in!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .foregroundColor(Color.MyTheme.pinkColor)
            
            Text("Click the button below to create an account and join the fun!")
                .font(.headline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
            
            Button {
                showOnbboarding.toggle()
            } label: {
                Text("Sign in / Sing up".uppercased())
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.MyTheme.pinkColor)
                    .cornerRadius(12)
                    .shadow(radius: 12)

            }
            .accentColor(Color.MyTheme.yourColor)
            
            Spacer()
            Spacer()
        }
        .padding(.all, 40)
        .background(Color.MyTheme.yourColor)
        .edgesIgnoringSafeArea(.all)
        .fullScreenCover(isPresented: $showOnbboarding) {
            OnboardingView()
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
