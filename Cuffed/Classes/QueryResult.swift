//
//  QueryResult.swift
//  Cuffed
//
//  Created by Evan Guan on 10/8/20.
//  Copyright © 2020 Evan Guan. All rights reserved.
//

import Foundation
import Firebase

class QueryResult {
    
    // The documentSnapshot itself
    var document:QueryDocumentSnapshot?
    
    // The social media from which this snapshot was fetched.
    var socialMedia:String?
    
    
}
