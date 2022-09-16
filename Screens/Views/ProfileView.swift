//
//  ProfileView.swift
//  CatGram
//
//  Created by Estefania Cano Robles on 10/09/22.
//

import SwiftUI

struct ProfileView: View {
    
    //@ObservedObject var posts: PostArrayObject
    
    var isMyprofile: Bool
    
    @State var profileDisplayName: String
    var profileUserID: String
    
    @State var profileImage: UIImage = UIImage(named: "logo.loading")!
    
    var posts: PostArrayObject
    
    @State var showSettings: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ProfileHeaderView(profileDisplayName: $profileDisplayName, profileImage: $profileImage, postArray: posts)
            Divider()
            ImageGridView(posts: posts)
        }
        .navigationBarTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
                                Button(action: {
            showSettings.toggle()
        }, label: {
            Image(systemName: "line.horizontal.3")
        })
                                    .accentColor(Color.MyTheme.pinkColor)
                                    .opacity(isMyprofile ? 1.0 : 0.0)
        
        )
        .onAppear(perform: {
            getProfileImage()
        })
        .sheet(isPresented: $showSettings) {
            SettingsView(userProfilePicture: $profileImage)
        }
    }
    
    // MARK: FUNCTIONS
    
    func getProfileImage() {
        
        ImageManager.shared.downloadProfileImage(userID: profileUserID) { image in
            if let image = image {
                self.profileImage = image
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView(isMyprofile: true, profileDisplayName: "Tuna", profileUserID: "", posts: PostArrayObject(userID: ""))
        }
    }
}
