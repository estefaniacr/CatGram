//
//  DataService.swift
//  CatGram
//
//  Created by Estefania Cano Robles on 11/09/22.
//

import Foundation

import SwiftUI
import FirebaseFirestore


// used to handle uploading and downloading data other than User to our Database
class DataService {
  
  static let shared = DataService()
  private init() { }
  
  private var REF_POSTS = DATABASE.collection("posts")
  // private var REF_REPORTS = DATABASE.collection("reports")
  
  @AppStorage(CurrentUserDefaultsKeys.userID) private var currentUserID: String?
  
  
    // MARK: CREATE FUNCTION
    
  // displayName and userID is the currently logged in user who
  // creates the post
  func uploadPost(image: UIImage, caption: String?, displayName: String, userID: String, handler: @escaping (_ success: Bool) -> Void) {
    
    let document = REF_POSTS.document()
    let postID = document.documentID
    
    // upload image to storage
      ImageManager.shared.uploadPostImage(postID: postID, image: image) { succes in
      
      if succes {
        // successfully uploaded image data to Storage
        // now upload post data to Database
        let postData: [String: Any] = [
          DatabasePostField.postID: postID,
          DatabasePostField.userID: userID,
          DatabasePostField.displayName: displayName,
          DatabasePostField.caption: caption!,
          DatabasePostField.createdAt: FieldValue.serverTimestamp()
        ]
        
        document.setData(postData) { error in
          if let error = error {
            print("error uploading data to post document:\n\(error)")
            handler(false)
            return
          }
          
          // return back to the app
          handler(true)
          return
        }
      } else {
        // error
        print("error uploading post image to firebase")
        handler(false)
          return
      }
    }
  }
  
  
    // used to report a post in our application
    // creates a report entry in a reports table in our database
    func deletePost(userID: String, postID: String, image: UIImage, handler: @escaping (_ success: Bool) -> Void) {
        
        let document = REF_POSTS.document(postID)
        
        // delete image to storage
        ImageManager.shared.deletePostImage(postID: postID, image: image) { success in
          
          if success {
            // successfully uploaded image data to Storage
            // now upload post data to Database
              
              document.delete() { error in
              if let error = error {
                print("error deleting data to post document:\n\(error)")
                handler(false)
                return
              }
              
              // return back to the app
              handler(true)
              return
            }
          } else {
            // error
            print("error deleting post image to firebase")
            handler(false)
              return
          }
        }
    }
    
  
  // uploads a comment to the database
  // display name and the user id is the creator of the comment
  func uploadComment(postID: String, content: String, displayName: String, userID: String, handler: @escaping (_ success: Bool, _ commentID: String?) -> Void) {
    
    let document = REF_POSTS.document(postID).collection(DatabasePostField.comments).document()
    let commentID = document.documentID
    
    let data: [String: Any] = [
      DatabaseCommentField.commentID: commentID,
      DatabaseCommentField.userID: userID,
      DatabaseCommentField.content: content,
      DatabaseCommentField.displayName: displayName,
      DatabaseCommentField.createdAt: FieldValue.serverTimestamp()
    ]
    
    document.setData(data) { error in
      if let error = error {
        print("Error uploading comment\n\(error)")
        handler(false, nil)
        return
      }
      
      handler(true, commentID)
    }
  }
  
  
  // downloads the posts by user id
  func downloadPostsForUser(userID: String, handler: @escaping (_ posts: [Post]) -> Void) {

    REF_POSTS.whereField(DatabasePostField.userID, isEqualTo: userID).getDocuments { querySnapshot, error in

      handler(self.getPostsFromSnapshot(querySnapshot))
    }
  }
  
  
  // downloads all the posts
  // gets the most recent posts
  func downloadPostsForFeed(handler: @escaping (_ posts: [Post]) -> Void) {
    
    // get the latest 50 posts
    REF_POSTS.order(by: DatabasePostField.createdAt, descending: true).limit(to: 50).getDocuments { querySnapshot, error in

      handler(self.getPostsFromSnapshot(querySnapshot))
    }
  }
  
  
  // downloads the comments for the post
  // passes down the comments[] in the callback handler
  func downloadComments(postID: String, handler: @escaping (_ comments: [Comment]) -> Void) {
    
    // order from oldest to newest - oldest will be at the top and most recent comment will be at the bottom
    REF_POSTS.document(postID).collection(DatabasePostField.comments)
      .order(by: DatabaseCommentField.createdAt, descending: false)
      .getDocuments { querySnapshot, error in
        
        handler(self.getCommentsFromSnapshot(querySnapshot))
      }
  }
  
  
  private func updatePostDisplayName(postID: String, displayName: String) {
    
    let data: [String: Any] = [DatabasePostField.displayName: displayName]
    
    REF_POSTS.document(postID).updateData(data)
  }
  
  
  private func getPostsFromSnapshot(_ querySnapshot: QuerySnapshot?) -> [Post] {
    
    var postArray: [Post] = []
    
    if let snapshot = querySnapshot, snapshot.documents.count > 0 {
      
      for document in snapshot.documents {
        
          if let userID = document.get(DatabasePostField.userID) as? String,
           let displayName = document.get(DatabasePostField.displayName) as? String,
           let timestamp = document.get(DatabasePostField.createdAt) as? Timestamp {
          
          let caption = document.get(DatabasePostField.caption) as? String
            let date = timestamp.dateValue()
          let postID = document.documentID
          
          
          let newPost = Post(postID: postID, userID: userID, username: displayName, caption: caption, createdAt: date, likeCount: 0, isLikedByUser: false)
          
          postArray.append(newPost)
        }
      }
        
    } else {
      print("No documents found for the user")
        return postArray
    }
    
    return postArray
  }
  
  
  private func getCommentsFromSnapshot(_ querySnapshot: QuerySnapshot?) -> [Comment] {
    
    var commentArray: [Comment] = []
    
    if let snapshot = querySnapshot, snapshot.documents.count > 0 {
      
      for document in snapshot.documents {
        
        if let userID = document.get(DatabaseCommentField.userID) as? String,
           let displayName = document.get(DatabaseCommentField.displayName) as? String,
           let content = document.get(DatabaseCommentField.content) as? String,
           let timestamp = document.get(DatabaseCommentField.createdAt) as? Timestamp {
         
          let newComment = Comment(commentID: document.documentID, userID: userID, username: displayName, content: content, createdAt: timestamp.dateValue())
          
          commentArray.append(newComment)
        }
      }
      
    } else {
      print("No documents found for the post")
    }
    
    return commentArray
  }
}
