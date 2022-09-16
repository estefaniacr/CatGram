//
//  ImageManager.swift
//  CatGram
//
//  Created by Estefania Cano Robles on 10/09/22.
//

import Foundation
import FirebaseStorage
import SwiftUI
import FirebaseAuth


// initialise a blank image cache
let imageCache = NSCache<AnyObject, UIImage>()


class ImageManager {
  
  static let shared = ImageManager()
  private init() { }
  
  private var REF_STORE = Storage.storage()
  
  
  func uploadProfileImage(userID: String, image: UIImage) {
    // get the path where image will be saved
    let path = getProfileImagePath(userID: userID)
    
    // clear the cache for the profile image so it will download the profile image for the other screen
    // we want to download the image again when the profile image is updated
    //imageCache.removeObject(forKey: path)
    
    // save image to path
   // DispatchQueue.global(qos: .userInteractive).async {
      self.uploadImage(path: path, image: image) { _ in
      }
    //}
  }
  
  
  func uploadPostImage(postID: String, image: UIImage, handler: @escaping (_ success: Bool) -> Void) {
    // get the path where image will be saved
    let path = getPostImagePath(postID: postID)
    
    // save image to path
    DispatchQueue.global(qos: .userInteractive).async {
      self.uploadImage(path: path, image: image) { success in
        
        DispatchQueue.main.async {
          handler(success)
        }
      }
    }
  }
    
  
  func downloadProfileImage(userID: String, handler: @escaping (_ image: UIImage?) -> Void) {
    // get the path
    let path = getProfileImagePath(userID: userID)
    
    // download the image from the path
    DispatchQueue.global(qos: .userInteractive).async {
      self.downloadImage(from: path) { image in
        DispatchQueue.main.async {
          handler(image)
        }
      }
    }
  }
  
  
  func downloadPostImage(postID: String, handler: @escaping (_ image: UIImage?) -> Void) {
    // get the path
    let path = getPostImagePath(postID: postID)
    
    // download the image from the path
    DispatchQueue.global(qos: .userInteractive).async {
      self.downloadImage(from: path) { image in
        DispatchQueue.main.async {
          handler(image)
        }
      }
    }
  }
    
    func deletePostImage(postID: String, image: UIImage, handler: @escaping (_ succes: Bool) -> Void) {
        
        // get the path
        let path = getPostImagePath(postID: postID)
        
        path.delete { error in
            if let error = error {
                print("Error deleting image\(error)")
                handler(false)
                return
                
            } else {
                print("Image deleted successfully")
                handler(true)
                return
            }
        }
    }
  
  
  /// returns the path for the profile image based on the userID
  private func getProfileImagePath(userID: String) -> StorageReference {
    
    let userPath = "users/\(userID)/profile"
    
    return REF_STORE.reference(withPath: userPath)
  }
  
  
  private func getPostImagePath(postID: String) -> StorageReference {
    
    // 1 becaUse we will be posting 1 image per post
    // we can make this number a variable and create posts with multiple pictures
    let postPath = "posts/\(postID)/1"
    
    return REF_STORE.reference(withPath: postPath)
  }
  
  
  // uploads the image to the path
    private func uploadImage(path: StorageReference, image: UIImage, handler: @escaping (_ success: Bool) -> ()) {
        
        
        var compression: CGFloat = 1.0 // Loops down by 0.05
        let maxFileSize: Int = 240 * 240 // Maximum file size that we want to save
        let maxCompression: CGFloat = 0.05 // Maximum compression we ever allow
        
        // Get image data
        guard var originalData = image.jpegData(compressionQuality: compression) else {
            print("Error getting data from image")
            handler(false)
            return
        }
        
        
        // Check maximum file size
        while (originalData.count > maxFileSize) && (compression > maxCompression) {
            compression -= 0.05
            if let compressedData = image.jpegData(compressionQuality: compression) {
                originalData = compressedData
            }
            print(compression)
        }
        
        
        // Get image data
        guard let finalData = image.jpegData(compressionQuality: compression) else {
            print("Error getting data from image")
            handler(false)
            return
        }
        
        // Get photo metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        metadata.customMetadata = ["uid": Auth.auth().currentUser!.uid]
        
        // Save data to path
        path.putData(finalData, metadata: metadata) { (_, error) in
            
            if let error = error {
                //Error
                print("Error uploading image. \(error)")
                handler(false)
                return
            } else {
                //Success
                print("Success uploading image")
                handler(true)
                return
            }
            
        }
        
    }
  
  
  // downloads an image given a path
  private func downloadImage(from path: StorageReference, handler: @escaping (_ image: UIImage?) -> Void) {
    
    // check if the image is already in the cache
    if let cachedImage = imageCache.object(forKey: path) {
      // image exists in cache return early
        print("Image found in cache")
      handler(cachedImage)
      return
    } else {
        
        path.getData(maxSize: 27 * 1024 * 1024) { imageData, error in
          
          if let data = imageData, let image = UIImage(data: data) {
            // success getting image data - cache it first
            imageCache.setObject(image, forKey: path)
              
              imageCache.setObject(image, forKey: path)
              handler(image)
              return
              
          } else {
              print("Error getting data from path for image")
              handler(nil)
              return
          }
        }
    }
  }
}
