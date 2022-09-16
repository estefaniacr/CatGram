//
//  AuthService.swift
//  CatGram
//
//  Created by Estefania Cano Robles on 10/09/22.
//

import Foundation
import FirebaseAuth
import UIKit
import FirebaseFirestore


let DATABASE = Firestore.firestore()


// used to authenticate users in Firebase
// used to handle user accounts in Firebase
class AuthService {
  
  static let shared = AuthService()
  private init() { }
  
  // users collection
  private var REF_USERS = DATABASE.collection("users")
  
  
  // Sign them into  Firebase Auth..
  func loginUserToFirebase(credential: AuthCredential, handler: @escaping (_ providerID: String?, _ isError: Bool, _ errorMessage: String?, _ isNewUser: Bool?, _ userID: String?) -> Void) {
    
    Auth.auth().signIn(with: credential) { result, error in
      
      if let error = error {
        print(error.localizedDescription)
        
        handler(nil, true, error.localizedDescription, nil, nil)
        return
      }
      
      // Check for providerID
      guard let providerID = result?.user.uid else {
        
        handler(nil, true, "Error getting the providcer ID", nil, nil)
        return
      }
      
      // check if the user already exists
      self.checkIfUserExistsInDatabase(providerID: providerID) { existingUserID in
        
        if let existingUserID = existingUserID {
          // user already exists - log in to app immediately
          handler(providerID, false, nil, false, existingUserID)
          
        } else {
          // user does not exist - create new user
          handler(providerID, false, nil, true, nil)
        }
      }
    }
  }
  
  
  // creates the user information and saves it into the database
  func createNewUserInDatabase(name: String, email: String, providerID: String, provider: String, profileImage: UIImage, handler: @escaping (_ userID: String?) -> Void) {
    
    // setup a user document in the user collection
    let document = REF_USERS.document()
    let userID = document.documentID

    // upload profile image to storage
    ImageManager.shared.uploadProfileImage(userID: userID, image: profileImage)
    
    // upload profile data to Firestore
    let userData: [String: Any] = [
      DatabaseUserField.displayName: name,
      DatabaseUserField.email: email,
      DatabaseUserField.providerID: providerID,
      DatabaseUserField.provider: provider,
      DatabaseUserField.userID: userID,
      DatabaseUserField.bio: "",
      DatabaseUserField.createdAt: FieldValue.serverTimestamp() // time of now
    ]
    
    document.setData(userData) { error in
      
      if let error = error {
        print("error uploading data using document", error.localizedDescription)
        handler(nil)
      } else {
        
        handler(userID)
      }
    }
  }
  
  
  // connect the user into the UI of the app
  // log them in the device
  func loginUserToApp(userID: String, handler: @escaping (_ success: Bool) -> Void) {
    // get the users info
    getUserInfo(userID: userID) { name, bio in
      
      guard let name = name, let bio = bio else {
        print("Error getting user info while logging in")
        handler(false)
        return
      }
      
      // success
      handler(true)
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        // set the user's info in our app - in the UserDefaults
        UserDefaults.standard.set(userID, forKey: CurrentUserDefaultsKeys.userID)
        UserDefaults.standard.set(bio, forKey: CurrentUserDefaultsKeys.bio)
        UserDefaults.standard.set(name, forKey: CurrentUserDefaultsKeys.displayName)
      }
    }
  }
  
  
  func getUserInfo(userID: String, handler: @escaping (_ name: String?, _ bio: String?) -> Void) {
    
    // becuase we save the documentID as userID
    REF_USERS.document(userID).getDocument { documentSnapshot, error in
      
      if let document = documentSnapshot,
         let name = document.get(DatabaseUserField.displayName) as? String,
         let bio = document.get(DatabaseUserField.bio) as? String {
        
        handler(name, bio)
        return
      }
      
      // we have an error
      print("error getting user info")
      handler(nil, nil)
    }
  }
  
  
  // logs the user out of the firebase and the applicaiton
  // returns a handler with a success boolean
  func logoutUser(handler: @escaping (_ success: Bool) -> Void) {
    
    do {
      try Auth.auth().signOut()
      
    } catch {
      print("Error Logging out\n\(error)")
      handler(false)
        return
    }
    
    handler(true)
    
      // Updated UserDefaults
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          
          let defaultsDictionary = UserDefaults.standard.dictionaryRepresentation()
          defaultsDictionary.keys.forEach { key in
              UserDefaults.standard.removeObject(forKey: key)
          }
      }
  }
  
  
  func updateUserDisplayName(userID: String, newDisplayName: String, handler: @escaping (_ success: Bool) -> Void) {
    
    let data: [String: Any] = [DatabaseUserField.displayName: newDisplayName]
    
    REF_USERS.document(userID).updateData(data) { error in
      if let error = error {
        print("Error updating user displayname\n\(error)")
        handler(false)
        return
      }
      
      handler(true)
    }
  }
  
  
  func updateUserBio(userID: String, newBio: String, handler: @escaping (_ success: Bool) -> Void) {
    
    let data: [String: Any] = [DatabaseUserField.bio: newBio]
    
    REF_USERS.document(userID).updateData(data) { error in
      if let error = error {
        print("Error updating user displayname\n\(error)")
        handler(false)
        return
      }
      
      handler(true)
    }
  }
  
  
  // checks the Firestore database if the user already exists given a provider id
  // if user exists user id (document id) is returned through a callback handler
  private func checkIfUserExistsInDatabase(providerID: String, handler: @escaping (_ existingUserID: String?) -> Void) {
    
    REF_USERS
      .whereField(DatabaseUserField.providerID, isEqualTo: providerID)
      .getDocuments { querySnaphot, error in
        
        if let snapshot = querySnaphot,
           snapshot.count > 0,
           let document = snapshot.documents.first {
          
          // because we set the user id to document id
          let existingUserID = document.documentID
          
          handler(existingUserID)
          return
        } else {
            // user do not exist in the db
            handler(nil)
            return
        }
      }
  }
}
