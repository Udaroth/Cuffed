//
//  Profile.swift
//  Cuffed
//
//  Created by Evan Guan on 15/12/19.
//  Copyright © 2019 Evan Guan. All rights reserved.
//

import Foundation
import SDWebImage
import Firebase


protocol ProfileProtocol {
    
    func profileRetrieved()
    
}

class Profile {
    
    // Variables
    var profileImage:String?
    var name:String!
    var bio:String?
    var uid:String?
    var border:Float?
    var gems:[String]? // An array which holds
    var socialHandles:[String:String]?
    var affiliations:[String]?
    
    
    // Utilities
    var dbRef:DatabaseReference?
    var delegate:ProfileProtocol?

    
    func retrieveData(uid:String?){
        
        guard uid != nil else { return }
        
        // Store the given uid
        self.uid = uid!
        
        // Init database reference
        dbRef = Database.database().reference()
        
        guard dbRef != nil else { return }
        
        gems = [String]()
        
        
        // Begin fetching operations
        dbRef?.child(Con.Database.users).child(uid!).observeSingleEvent(of: .value, with: { (snapshot:DataSnapshot) in
            
            
            let profileDict = snapshot.value as? [String:Any]
            
            guard profileDict != nil else { return }
            
            // Fetch basic data here
            self.name = profileDict![Con.Database.name] as? String
            
            self.bio = profileDict![Con.Database.bio] as? String
            
            self.border = profileDict![Con.Database.border] as? Float
            
            // Store urlString into profileImage
            self.profileImage = profileDict![Con.Database.profileImage] as? String
            
            // Fetch gems
            let gems = profileDict![Con.Database.gems] as? [String:String]
            
            // Make sure the gems array is empty before we begin appending to it
            self.gems = [String]()
            
            for media in Con.socialMedia.smArray {
                
                if gems?[media] == Con.Database.yes {
                    // A Gem was earnt for this media
                    self.gems?.append(media)
                    
                }
                
            }
            
            self.socialHandles = profileDict![Con.Database.social] as? [String:String]
            
            DispatchQueue.main.async {
                self.delegate?.profileRetrieved()
            }
            

            // We don't put in parameters because the profile cell should be able to retrieve all this information just by referring to the objects themselves
            
            
        })
        
        
   
        
    }
    
    
    
    
    
    
}
