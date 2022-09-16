//
//  SettingsView.swift
//  CatGram
//
//  Created by Estefania Cano Robles on 10/09/22.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var showSignOutError: Bool = false
    @Binding var userProfilePicture: UIImage
    
    var body: some View {

        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                
                // MARK: SECTION 1: CATGRAM
                GroupBox(label: SettingsLabelView(labelText: "CatGram", labelImage: "dot.radiowaves.left.and.right"), content: {
                    HStack(alignment: .center, spacing: 10) {
                        Image("logo.transparent")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80, alignment: .center)
                            .cornerRadius(12)
                        
                        Text("CatGram is the best app for posting images of your cat and sharing them accross the world. We are a cat-loving comunity and we're happy to have you!")
                            .font(.footnote)
                    }
                })
                .padding()
                
                // MARK: SECTION 2: PROFILE
                GroupBox(label: SettingsLabelView(labelText: "Profile", labelImage: "person.fill"), content: {
                    
                    NavigationLink {
                        SettingsEditTextView(submissionText: "Current display name", title: "Display Name", description: "You can edit your display name here. This will be seen by other users on your profile and your posts!", placeholder: "Your display name here...")
                    } label: {
                        SettingsRowView(leftIcon: "pencil", text: "Display name", color: Color.MyTheme.pinkColor)
                    }
                    
                    NavigationLink {
                        SettingsEditTextView(submissionText: "Current bio here", title: "Profile Bio", description: "Your bio is a great place to let other users know a little about you. It will be shown on your profile only.", placeholder: "Your bio here...")
                    } label: {
                        SettingsRowView(leftIcon: "text.quote", text: "Bio", color: Color.MyTheme.pinkColor)
                    }

                    NavigationLink {
                        SettingsEditImageView(title: "Profile picture", description: "Your profile picture will be shown on your profile and on your posts. Most users make it an image of themselves or of their cat!", selectedImage: userProfilePicture, profileImage: $userProfilePicture)
                    } label: {
                        SettingsRowView(leftIcon: "photo", text: "Profile picture", color: Color.MyTheme.pinkColor)
                    }

                    Button {
                        signOut()
                    } label: {
                        
                        SettingsRowView(leftIcon: "figure.walk", text: "Sign out", color: Color.MyTheme.pinkColor)
                    }
                    .alert(isPresented: $showSignOutError) {
                        return Alert(title: Text("Error signin out 🥵"))
                    }
                })
                .padding()
                
                // MARK: SECTION 3: APPLICATION
                GroupBox(label: SettingsLabelView(labelText: "Application", labelImage: "apps.iphone"), content: {
                    
                    Button {
                        openCustomURL(urlString: "https://google.com")
                    } label: {
                        SettingsRowView(leftIcon: "folder.fill", text: "Privacy Policy", color: Color.MyTheme.yourColor)
                    }

                    
                    Button {
                        openCustomURL(urlString: "https://firebase.com")
                    } label: {
                        SettingsRowView(leftIcon: "folder.fill", text: "Terms and Conditions", color: Color.MyTheme.yourColor)
                    }

                    Button {
                        openCustomURL(urlString: "https://google.com")
                    } label: {
                        SettingsRowView(leftIcon: "globe", text: "CatGram website", color: Color.MyTheme.yourColor)
                    }

                    
                })
                .padding()
                
                // MARK: SECTION 4: SIGN OFF
                GroupBox {
                    Text("CatGram was made with love. \n All Rights Reserved \n Cool Apps Inc. \n Copyright 2022 🐧")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .padding(.bottom, 80)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(leading:
                                    Button(action: {
                presentationMode.wrappedValue.dismiss()
            },
                                           label: {
                Image(systemName: "xmark")
                    .font(.title2)
            }).accentColor(.primary)
            )
        }
    }
    
    // MARK: FUNCTIONS
    
    func openCustomURL(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func signOut() {
        AuthService.shared.logoutUser { success in
            if success {
                print("Successfully logged out")
                
                // Dismiss setting view
                self.presentationMode.wrappedValue.dismiss()
                
            } else {
                print("Error loggin out")
                self.showSignOutError.toggle()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    
    @State static var image: UIImage = UIImage(named: "cat1")!
    
    static var previews: some View {
        SettingsView(userProfilePicture: $image)
    }
}
