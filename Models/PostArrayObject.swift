//
//  PostArrayObject.swift
//  CatGram
//
//  Created by Estefania Cano Robles on 09/09/22.
//

import Foundation

class PostArrayObject: ObservableObject {
    
    @Published var dataArray = [Post]()
    @Published var postCountString = "0"
    
    /// USED FOR SINGLE POST SELECTION
    init(post: Post) {
        self.dataArray.append(post)
    }
    
    /// USED FOR GETTING POSTS FROM USER PROFILE
    init(userID: String) {
        
        print("GET POSTS FOR USER ID \(userID)")
        DataService.shared.downloadPostsForUser(userID: userID) { posts in
            
            let sortedPosts = posts.sorted { (post1, post2) -> Bool in
                return post1.createdAt > post2.createdAt
            }
            
            self.dataArray.append(contentsOf: sortedPosts)
            self.updateCounts()
        }
    }
    
    /// USED FOR FEED
    init(shuffled: Bool) {
        
        print("GET POSTS FOR FEED. SHUFFLED: \(shuffled)")
        
        DataService.shared.downloadPostsForFeed { posts in
            if shuffled {
                let shuffledPosts = posts.shuffled()
                self.dataArray.append(contentsOf: shuffledPosts)
            } else {
                self.dataArray.append(contentsOf: posts)
            }
        }
    }
    
    func updateCounts() {
        
        // post count
        self.postCountString = "\(self.dataArray.count)"
    }
}

