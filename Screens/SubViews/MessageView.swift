//
//  MessageView.swift
//  CatGram
//
//  Created by Estefania Cano Robles on 09/09/22.
//

import SwiftUI

struct MessageView: View {
    
    @State var comment: Comment
    
    var body: some View {
        
        HStack {
            
            
            // MARK: PROFILE IMAGE
            Image("cat1")
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40, alignment: .center)
                .cornerRadius(20)
            
            VStack(alignment: .leading, spacing: 4, content: {
                
                
                // MARK: USERNAME
                Text(comment.username)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                
                // MARK: CONTENT
                Text(comment.content)
                    .padding(.all, 10)
                    .foregroundColor(.primary)
                    .background(Color.MyTheme.yourColor).cornerRadius(10)
            })
            
            Spacer()
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    
    static var comment: Comment = Comment(commentID: "", userID: "", username: "DaBeat", content: "This post is great", createdAt: Date())
    
    static var previews: some View {
        MessageView(comment: comment)
            .previewLayout(.sizeThatFits)
    }
}
