//
//  Retrieve.swift
//  Cuffed
//
//  Created by Evan Guan on 21/12/19.
//  Copyright © 2019 Evan Guan. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class Retrieve {
    
    static func retrieveUID() -> String? {
        
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        
        return uid
        
    }
    
    
}
