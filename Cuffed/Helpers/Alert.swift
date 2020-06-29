//
//  Alert.swift
//  Cuffed
//
//  Created by Evan Guan on 15/2/20.
//  Copyright © 2020 Evan Guan. All rights reserved.
//

import Foundation
import UIKit

struct Alert {
    
    static func showBasicAlert(on vc: UIViewController, with title: String, message: String){
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        vc.present(alert, animated: true)
        
        
    }
    
    
    
}
