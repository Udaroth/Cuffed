//
//  SentMessageTableViewCell.swift
//  Cuffed
//
//  Created by Evan Guan on 23/1/20.
//  Copyright © 2020 Evan Guan. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class SentMessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var senderImageView: UIImageView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var messageBubbleView: UIView!
    
    @IBOutlet weak var innerImageView: UIImageView!
    
    @IBOutlet weak var whiteBackDropImageView: UIImageView!
    
    
    var dbRef:DatabaseReference?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dbRef = Database.database().reference()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func styleCell(_ message:String, uid:String) {
        
        self.messageLabel.text = message
        
        dbRef?.child(Con.Database.users).child(uid).observe(.value, with: { (snapshot) in
            
            let userDict = snapshot.value as? [String:Any]
            
            guard userDict != nil else { return }
            
            let urlString = userDict![Con.Database.profileImage] as? String
            
            guard urlString != nil else { return }
            
            let url = URL(string: urlString!)
            
            self.senderImageView.sd_setImage(with: url) { (image, errorr, cacheType, url) in
                
                self.senderImageView.image = image
                
            }
            
            let border = userDict![Con.Database.border] as? Float
            
            Utilities.styleProfileIconBorder(self.senderImageView, border: border!, thickness: 5)
            
            Utilities.styleSentMessageCell(self.innerImageView, self.whiteBackDropImageView, label:self.messageLabel, isGreen: true)
            

            
        })
        

        
        
        
    }

}
