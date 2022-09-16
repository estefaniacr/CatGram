//
//  PostView.swift
//  CatGram
//
//  Created by Estefania Cano Robles on 09/09/22.
//

import SwiftUI

struct PostView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var post: Post
    var showHeaderAndFooter: Bool
    
    @State var profileImage : UIImage = UIImage(named: "logo.loading")!
    @State var postImage: UIImage = UIImage(named: "logo.loading")!
    
    @State var showAlert: Bool = false
    @State var postDeletedSuccessfully: Bool = false
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            
            // MARK: HEADER
            if showHeaderAndFooter {
                HStack {
                    
                    NavigationLink(destination: LazyView(content: {
                        ProfileView(isMyprofile: false, profileDisplayName: post.username, profileUserID: post.userID, posts: PostArrayObject(userID: post.userID))
                    }), label: {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30, alignment: .center)
                            .cornerRadius(15)
                        
                        Text(post.username)
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                    })

                    Spacer()
                    
                    Image(systemName: "ellipsis")
                        .font(.headline)
                }
                .padding(.all, 6)
            }

            //MARK: IMAGE
            
            Image(uiImage: postImage)
                .resizable()
                .scaledToFit()
            
            //MARK: FOOTER
            if showHeaderAndFooter {
                HStack(alignment: .center, spacing: 20, content: {
                    
                    
                    Image(systemName: "heart")
                        .font(.title3)
                    
                    
                    // MARK: COMMENT ICON
                    
                    NavigationLink {
                        CommenstView()
                        
                    } label: {
                        Image(systemName: "bubble.middle.bottom")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }
                    
                    Image(systemName: "paperplane")
                        .font(.title3)
                    
                    Button {
                        deletePost()
                    } label: {
                        Image(systemName: "trash")
                            .font(.title3)
                    }
                    
                    Spacer()
                })
                .padding(.all, 6)
                
                
                if let caption = post.caption {
                    
                    HStack {
                        Text(caption)
                        Spacer(minLength: 0)
                    }
                    
                    .padding(.all, 6)
                }
            }
        })
        .onAppear {
            getImages()
        }
        .alert(isPresented: $showAlert) { () -> Alert in
            getAlert()
        }
    }

    
    private func getImages() {
        // Get profile image
        ImageManager.shared.downloadProfileImage(userID: post.userID) { image in
            if let image = image {
                self.profileImage = image
            }
        }
        
        // Get post image
        ImageManager.shared.downloadPostImage(postID: post.postID) { image in
            if let image = image {
                self.postImage = image
            }
        }
    }
    
    private func deletePost() {
        DataService.shared.deletePost(userID: post.userID, postID: post.postID, image: postImage) { success in
                self.postDeletedSuccessfully = success
                self.showAlert.toggle()
        }
    }
    
    func getAlert() -> Alert {
        
        if postDeletedSuccessfully {
            
            return Alert(title: Text("Successfully deleted post! 🥳"), message: nil, dismissButton: .default(Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        } else {
            return Alert(title: Text("Error deleting post 😭"))
        }
    }
    
}

struct PostView_Previews: PreviewProvider {
    
    static var post: Post = Post(postID: "", userID: "", username: "Steff", caption: "This is a test caption", createdAt: Date(), likeCount: 0, isLikedByUser: false)
    
    static var previews: some View {
        PostView(post: post, showHeaderAndFooter: true)
            .previewLayout(.sizeThatFits)
    }
}
