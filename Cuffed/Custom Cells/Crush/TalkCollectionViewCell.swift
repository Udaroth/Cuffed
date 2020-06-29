//
//  TalkCollectionViewCell.swift
//  Cuffed
//
//  Created by Evan Guan on 29/1/20.
//  Copyright © 2020 Evan Guan. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class TalkCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var talkContainerView: UIView!
    
    @IBOutlet weak var greenBackdropImageView: UIImageView!
    
    @IBOutlet weak var whiteCircularBackdropImageView: UIImageView!
    
    @IBOutlet weak var talkImageView: UIImageView!

    @IBOutlet weak var talkNameLabel: UILabel!
    
    var cardUID:String?
    
    var borderFloat:Float?
    
    
    func styleCell(_ uid:String?) {
        
        talkImageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        Utilities.styleTalkCard(greenBackdropImageView, talkContainerView)
        
        whiteCircularBackdropImageView.layer.cornerRadius = whiteCircularBackdropImageView.frame.width/2
        
        talkImageView.layer.cornerRadius = talkImageView.frame.width/2
        
        whiteCircularBackdropImageView.backgroundColor = .white
        
        // Begin userbased customization
        
        guard uid != nil && uid != "" else { return }
        
        // Store the UID for detailed display purposes
        
        cardUID = uid
        
        // Fetch name and profile image using uid
        
        let dbRef = Database.database().reference()
        
        dbRef.child(Con.Database.users).child(cardUID!).observe(.value) { (snapshot) in
            
            let dataDict = snapshot.value as? [String:Any]
            
            guard dataDict != nil else { return }
            
            self.talkNameLabel.text = dataDict![Con.Database.name] as? String
            
            self.borderFloat = dataDict![Con.Database.border] as? Float
             
            let urlString = dataDict![Con.Database.profileImage] as? String
            
            guard urlString != nil else { return }
            
            let url = URL(string: urlString!)
            
            self.talkImageView.sd_setImage(with: url) { (image, error, cacheType, url) in
                
                if error != nil { return }
                
                self.talkImageView.image = image
                
                
            }
            
//            Utilities.styleProfileIconBorder(self.talkImageView, border: self.borderFloat!, thickness: 8)
            
            
            
        }
        
        
    }
    
}
