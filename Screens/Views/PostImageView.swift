//
//  PostImageView.swift
//  CatGram
//
//  Created by Estefania Cano Robles on 10/09/22.
//

import SwiftUI

struct PostImageView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var captionText: String = ""
    @Binding var imageSelected: UIImage
    
    @AppStorage(CurrentUserDefaultsKeys.userID) var currentUserID: String?
    @AppStorage(CurrentUserDefaultsKeys.displayName) var currentUserDisplayName: String?
    
    // Alert
    @State var showAlert: Bool = false
    @State var postUploadedSuccessfully: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title)
                        .padding()
                }
            .accentColor(.primary)
                
                Spacer()
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                Image(uiImage: imageSelected)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200, alignment: .center)
                    .cornerRadius(12)
                    .clipped()
                
                TextField("Add your caption here..", text: $captionText)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.beigeColor)
                    .cornerRadius(12)
                    .font(.headline)
                    .padding(.horizontal)
                    .autocapitalization(.sentences)
                
                Button {
                    postPicture()
                } label: {
                    Text("Post Picture".uppercased())
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(Color.MyTheme.yourColor)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .accentColor(Color.MyTheme.pinkColor)

            }
            .alert(isPresented: $showAlert) { () -> Alert in
                getAlert()
            }
        }
    }
    
    // MARK: FUNCTIONS
    
    func postPicture() {
        print("Post picture to database")
        guard let userID = currentUserID, let displayName = currentUserDisplayName else {
            print("Error getting userID or displayName while posting image")
            return
        }
        
        DataService.shared.uploadPost(image: imageSelected, caption: captionText, displayName: displayName, userID: userID) { success in
            self.postUploadedSuccessfully = success
            self.showAlert.toggle()
        }
        
    }
    
    func getAlert() -> Alert {
        
        if postUploadedSuccessfully {
            
            return Alert(title: Text("Successfully uploaded post! 🥳"), message: nil, dismissButton: .default(Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        } else {
            return Alert(title: Text("Error uploading post 😭"))
        }
    }
}

struct PostImageView_Previews: PreviewProvider {
    
    @State static var image = UIImage(named: "cat1")!
    static var previews: some View {
        PostImageView(imageSelected: $image)
    }
}
