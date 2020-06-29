//
//  Funcs.swift
//  Cuffed
//
//  Created by Evan Guan on 20/12/19.
//  Copyright © 2019 Evan Guan. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth


class Funcs {
    
    
    static func uploadExtraImage(image: UIImage) {
        
        // Get data representation of the image
        let photoData = image.jpegData(compressionQuality: 0.1)
        
        guard photoData != nil else {
            print("Couldn't turn the image into data")
            return
        }
        
        // Get a storage reference
        let userID = Auth.auth().currentUser!.uid
        let filename = UUID().uuidString
        
        let ref = Storage.storage().reference().child("users/\(userID)/extraImages/\(filename).jpg")
        
        // Upload the photo
        ref.putData(photoData!, metadata: nil) { (metadata, error) in
            
            if error != nil {
                // An error occured during upload
                
            } else {
                
                // Upload successful, create database entry
                createExtraImageEntry(ref: ref)
                
            }
            
            
        }
        
        
    }
    
    private static func createExtraImageEntry(ref:StorageReference) {
        
        
        // Get download url for the photo
        ref.downloadURL { (url, error) in
            
            if error != nil {
                
                return
            } else {
                
                // Check user
                guard let uid = Retrieve.retrieveUID() else { return }
                
                // Create photoData
                let photoData = url!.absoluteString
                
                // Create reference to where extra images are stored
                let dbRef = Database.database().reference().child(Con.Database.users).child(uid).child(Con.Database.extraImages).childByAutoId()
                
                // Update the value stored to hold the new image url
                dbRef.setValue(photoData) { (error, dbRef) in
                    
                    if error != nil { return }
                    
                    else {
                        // Successful entry
                        
                    }
                    
                    
                }
            }
            
            
        }
        
    }
    

    
    static func uploadProfileImage(image:UIImage) {
        
        // Get data representation of the image
        let photoData = image.jpegData(compressionQuality: 0.1)
        
        guard photoData != nil else {
            print("Couldn't turn the image into data")
            return
        }
        
        // Get a storage reference
        let userID = Auth.auth().currentUser!.uid
        let filename = UUID().uuidString
        
        let ref = Storage.storage().reference().child("users/\(userID)/\(filename).jpg")
        
        // Upload the photo
        ref.putData(photoData!, metadata: nil) { (metadata, error) in
            
            if error != nil {
                // An error occured during upload
                
            } else {
                
                // Upload successful, create database entry
                createProfileImageEntry(ref: ref)
                
            }
            
            
        }
        
    }
    
    private static func createProfileImageEntry(ref:StorageReference) {
        
        
        // Get download url for the photo
        ref.downloadURL { (url, error) in
            
            if error != nil {
                
                return
            } else {
                
                // Check user
                guard let uid = Retrieve.retrieveUID() else { return }
                
                // Create photoData
                let photoData = url!.absoluteString
                
                // Create reference to where profilexsimages are stored
                let dbRef = Database.database().reference().child(Con.Database.users).child(uid).child(Con.Database.profileImage)
                
                // Update the value stored to hold the new image url
                dbRef.setValue(photoData) { (error, dbRef) in
                    
                    if error != nil { return }
                    
                    else {
                        // Successful entry
                        
                    }
                    
                    
                }
            }
            
            
        }
        
        // Write a database entry
        
    }
    
    
}
