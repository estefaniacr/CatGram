//
//  ProfileHeaderView.swift
//  CatGram
//
//  Created by Estefania Cano Robles on 10/09/22.
//

import SwiftUI

struct ProfileHeaderView: View {
    
    @Binding var profileDisplayName: String
    @Binding var profileImage: UIImage
    @ObservedObject var postArray: PostArrayObject
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            
            // MARK: PROFILE IMAGE
            Image(uiImage: profileImage)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120, alignment: .center)
                .cornerRadius(60)
            
            // MARK: USER NAME
            Text(profileDisplayName)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            
            // MARK: BIO
//            Text("Text here")
//                .font(.body)
//                .fontWeight(.regular)
            
            HStack(alignment: .center, spacing: 20) {
                
                
                // MARK: POSTS
                VStack(alignment: .center, spacing: 5) {
                    Text(postArray.postCountString)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Capsule()
                        .fill(Color.gray)
                        .frame(width: 20, height: 2, alignment: .center)
                    
                    Text("Posts")
                        .font(.callout)
                        .fontWeight(.medium)
                    
                }
                
                // MARK: LIKES
//                VStack(alignment: .center, spacing: 5) {
//                    Text("20")
//                        .font(.title2)
//                        .fontWeight(.bold)
//
//                    Capsule()
//                        .fill(Color.gray)
//                        .frame(width: 20, height: 2, alignment: .center)
//
//                    Text("Likes")
//                        .font(.callout)
//                        .fontWeight(.medium)
//
//                }
                
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    
    @State static var name: String = "Tuna"
    @State static var image: UIImage = UIImage(named: "cat1")!
    
    static var previews: some View {
        ProfileHeaderView(profileDisplayName: $name, profileImage: $image, postArray: PostArrayObject(shuffled: false))
            .previewLayout(.sizeThatFits)
    }
}
