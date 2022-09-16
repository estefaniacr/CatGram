//
//  SettingsEditImageView.swift
//  CatGram
//
//  Created by Estefania Cano Robles on 10/09/22.
//

import SwiftUI

struct SettingsEditImageView: View {
    @State var title: String
    @State var description: String
    @State var selectedImage: UIImage // image shown on this screen
    @Binding var profileImage: UIImage // image shown on this profile
    @State var sourceType: UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
    
    @State var showImagePicker: Bool = false
    
    @AppStorage(CurrentUserDefaultsKeys.userID) var currentUserID: String?
    @State var showSuccessAlert: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text(description)
                Spacer(minLength: 0)
            }
            
            Image(uiImage: selectedImage)
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200, alignment: .center)
                .clipped()
                .cornerRadius(12)
            
            Button(action: {
                showImagePicker.toggle()
            }, label: {
                Text("Import".uppercased())
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.beigeColor)
                    .cornerRadius(12)
                
                
            })
            .accentColor(Color.MyTheme.pinkColor)
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(imageSelected: $selectedImage, sourceType: $sourceType)
            }
            
            Button(action: {
                saveImage()
            }, label: {
                Text("Save".uppercased())
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.yourColor)
                    .cornerRadius(12)
                
                
            })
            .accentColor(Color.MyTheme.pinkColor)

            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .navigationBarTitle(title)
        .alert(isPresented: $showSuccessAlert) { () -> Alert in
            return Alert(title: Text("Success 🥳"), message: nil, dismissButton: .default(Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
    }
    
    // MARK: FUNCTIONS
    
    func saveImage() {
        
        guard let userID = currentUserID else { return }
        
        // Update the UI of the profile
        self.profileImage = selectedImage
        
        // Update profile image in database
        ImageManager.shared.uploadProfileImage(userID: userID, image: selectedImage)
        
        self.showSuccessAlert.toggle()
    }
}

struct SettingsEditImageView_Previews: PreviewProvider {
    
    @State static var image: UIImage = UIImage(named: "cat1")!
    
    static var previews: some View {
        NavigationView {
            SettingsEditImageView(title: "Title", description: "Description", selectedImage: UIImage(named: "cat1")!, profileImage: $image)
        }
    }
}
