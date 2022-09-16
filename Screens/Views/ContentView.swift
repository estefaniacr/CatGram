//
//  ContentView.swift
//  CatGram
//
//  Created by Estefania Cano Robles on 08/09/22.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage(CurrentUserDefaultsKeys.userID) var currentUserID:  String?
    @AppStorage(CurrentUserDefaultsKeys.displayName) var currentUserDisplayName: String?
    
    let feedPosts = PostArrayObject(shuffled: false)
    let browsePosts = PostArrayObject(shuffled: true)
    
    var body: some View {
        TabView {
            NavigationView {
                FeedView(posts: feedPosts, title: "Feed")
            }
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Feed")
                }
            
            NavigationView {
                BrowseView(posts: browsePosts)
            }
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Browse")
                }
            
            UploadView()
                .tabItem {
                    Image(systemName: "square.and.arrow.up.fill")
                    Text("Upload")
                }
            
            ZStack {
                
                if let userID = currentUserID, let displayName = currentUserDisplayName {
                    NavigationView {
                        ProfileView(isMyprofile: true, profileDisplayName: displayName, profileUserID: userID, posts: PostArrayObject(userID: userID))
                    }
                } else {
                    SignUpView()
                }
                
            }
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .accentColor(Color.MyTheme.pinkColor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

