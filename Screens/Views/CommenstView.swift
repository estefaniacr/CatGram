//
//  CommenstView.swift
//  CatGram
//
//  Created by Estefania Cano Robles on 09/09/22.
//

import SwiftUI

struct CommenstView: View {
    
    @State var submissionText: String = ""
    @State var commentArray = [Comment]()
    
    var body: some View {
        VStack {
            
            ScrollView {
                
                LazyVStack {
                    ForEach(commentArray, id: \.self) { comment in
                        MessageView(comment: comment)
                    }
                }
            }
            
            HStack {
                
                Image("cat1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
                
                TextField("Add a comment here...", text: $submissionText)
                
                
                Button(action: {
                    
                }, label: {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                })
                .accentColor(Color.MyTheme.pinkColor)
            }
            .padding(.all, 6)
        }
        .navigationBarTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            getComments()
        }
        
    }
    
    // MARK: FUNCTIONS
    
    func getComments() {
        
        print("Get comments from database")
        
        let comment1 = Comment(commentID: "", userID: "", username: "Tuna", content: "First comment", createdAt: Date())
        let comment2 = Comment(commentID: "", userID: "", username: "Panthro", content: "Hi fellows", createdAt: Date())
        let comment3 = Comment(commentID: "", userID: "", username: "Steff", content: "Good info", createdAt: Date())
        let comment4 = Comment(commentID: "", userID: "", username: "Bengali", content: "First comment", createdAt: Date())
        
        self.commentArray.append(comment1)
        self.commentArray.append(comment2)
        self.commentArray.append(comment3)
        self.commentArray.append(comment4)
    }
}

struct CommenstView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            CommenstView()
        }
    }
}
