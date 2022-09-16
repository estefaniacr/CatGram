//
//  Enums & Structs.swift
//  CatGram
//
//  Created by Estefania Cano Robles on 10/09/22.
//

import Foundation


// Fields within the User Document in Database
// these are the field names / keys
struct DatabaseUserField {
  
  private init() { }
  
  static let displayName = "display_name"
  static let email = "email"
  static let providerID = "provider_id"
  static let provider = "provider"
  static let userID = "user_id"
  static let bio = "bio"
  static let createdAt = "created_at"
  
}


// keYs for the UserDefaults saved within app
struct CurrentUserDefaultsKeys {
  
  private init() { }
  
  static let displayName = "display_name"
  static let userID = "user_id"
  static let bio = "bio"
  
}


// Fields within the Post Document in Database
// these are the field names / keys
struct DatabasePostField {
  
  private init() { }
  
  static let postID = "post_id"
  static let userID = "user_id"
  static let displayName = "display_name"
  static let caption = "caption"
  static let createdAt = "created_at"
  
//  static let likeCount = "like_count" // INT
//  static let likedBy = "liked_by" // String[]
  
  static let comments = "comments" // sub-collection, nested object Comment
}


// Fields within the Report Document in Database in a Report table
// these are the field names / keys
struct DatabaseReportsField {
  
  private init() { }
  
  static let content = "content"
  static let postID = "post_id"
  static let createdAt = "created_at"
  
}

// Fields within the Comment Document in Database as a sub document for Post
// these are the field names / keys
struct DatabaseCommentField {
  
  private init() { }
  
  static let commentID = "comment_id"
  static let userID = "user_id"
  static let displayName = "display_name"
  static let content = "content"
  static let createdAt = "created_at"

}
