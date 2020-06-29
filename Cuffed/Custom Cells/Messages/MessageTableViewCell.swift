//
//  MessageTableViewCell.swift
//  Cuffed
//
//  Created by Evan Guan on 20/1/20.
//  Copyright © 2020 Evan Guan. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class MessageTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var chatWindowImageVIew: UIImageView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    var profile:Profile?
    
    var dbRef:DatabaseReference?
    
    var interfacePrepared:Bool?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profile = Profile()

        profile?.delegate = self
        
        dbRef = Database.database().reference()


    }
    
    func styleCell(_ uid:String?) {
        
        interfacePrepared = false
            
        guard uid != nil else { return }
        
        // Retrieve information for conversation cell
        profile?.retrieveData(uid: uid)
        
        let user = Retrieve.retrieveUID()
        
        guard user != nil else { return }
        
        // Style conversation bubble according to readStatus
    dbRef?.child(Con.Database.messages).child(user!).child(Con.Database.readStatus).child(uid!).observe(.value, with: { (snapshot) in
            
            let readStatus = snapshot.value as? String
            
            guard readStatus != nil else { return }
            
            if readStatus == "true" {
                
                Utilities.styleHollowImageViewGreen(self.chatWindowImageVIew, name: self.nameLabel, message:self.messageLabel)
                
            } else {
                
                Utilities.styleFilledImageViewGreen(self.chatWindowImageVIew, name: self.nameLabel, message: self.messageLabel)
                
            }
            
            
        })
        
        
        
        // Retrieve latest message
        dbRef?.child(Con.Database.messages).child(user!).child(Con.Database.chatLog).child(uid!).observe(.value, with: { (snapshot) in
            
            let messageDict = snapshot.value as? [String:Any]
            
            guard messageDict != nil else { return }
            
            // Reorder the chatlog
            let sortedMessages = messageDict!.sorted(by: { $0.key > $1.key })
            
            // The first item in this array is the latest message
            let messageItem = sortedMessages[0]
            
            // Store the content and sender tuple into detailDict
            let detailDict = messageItem.value as? [String:String]
            
            guard detailDict != nil else { return }
            
            // Update label
            self.messageLabel.text = detailDict![Con.Database.messageContent]

            
        })
        
        // Observer for value change
        dbRef?.child(Con.Database.messages).child(user!).child(Con.Database.chatLog).child(uid!).observe(.value, with: { (snapshot) in
            
            // If it is the first call, we want to ignore it
            if self.interfacePrepared == false {
                
                self.interfacePrepared = true
                
                return
            }
            
            // At this point, this function should only be called when a childAdded has actually been observed
            
            // Whenever a new message is added to the database
            
            // Check if the user is currently inside the detailView for this uid
            if StaticVariables.insideDetailView[uid!] == true {
                // If yes, we update the read status in the database to true
                self.dbRef?.child(Con.Database.messages).child(user!).child(Con.Database.readStatus).child(uid!).setValue("true")

                
            } else {
            // if no, we update the read status in the database to false; the message has not been read
                self.dbRef?.child(Con.Database.messages).child(user!).child(Con.Database.readStatus).child(uid!).setValue("false")

                
            }


            
        })
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension MessageTableViewCell: ProfileProtocol {
    func profileRetrieved() {
        
        // Fetch the border value dynamically
        Utilities.styleProfileIconBorder(iconImageView, border: profile!.border ?? 0, thickness: 5)
        
        nameLabel.text = profile!.name
        
        let url = URL(string: profile!.profileImage!)
        
        iconImageView.sd_setImage(with: url) { (image, error, cachetype, url) in

            if error != nil {
                print(error?.localizedDescription ?? "Error retrieving profile image")
            }

            self.iconImageView.image = image

        }
        
        
    }
    
    
}
