//
//  MessageModel.swift
//  Cuffed
//
//  Created by Evan Guan on 22/1/20.
//  Copyright © 2020 Evan Guan. All rights reserved.
//

import Foundation
import Firebase


protocol MessageModelProtocol {
    
    func messageRetrieved(_ messages:Messages)
    
}

class MessageModel {
    
    var delegate:MessageModelProtocol?
    
    func getMessages() {
        
        // Create message instance to store information required for table construction
        
        let message = Messages()
        
        // Create database reference
        
        let dbRef = Database.database().reference()
        
        // Access the number of messages to present
        
        guard let uid = Retrieve.retrieveUID() else { return }
        // Read from database
        dbRef.child(Con.Database.messages).child(uid).child(Con.Database.convoCount).observe(.value, with: { (snapshot) in

            message.numOfConversations = snapshot.value as? Int ?? 0
            
            self.delegate?.messageRetrieved(message)

        })
        
        // Access the list of recipients
        dbRef.child(Con.Database.messages).child(uid).child(Con.Database.timeStamps).observe(.value, with: { (snapshot:DataSnapshot) in
            
            // Retrieve all message recipients into an array
            let recipientsDict = snapshot.value as? [String:String]
            // Guard dictinoary not nil
            guard recipientsDict != nil else { return }
            // Order the dictinoary into most recent to least recent
            let sortedConvos = recipientsDict!.sorted(by: { $0.value > $1.value })
            // Create an array to store all the recipients in the order
            var recipients = [String]()
            // Append all the recipients
            for (key, _) in sortedConvos {
                recipients.append(key)
            }
            // Store the recipients array into the message instance
            message.recipients = recipients
            
            // Set up insideDetailView dictionary item, for every recipients that exists
            // Set to true when user taps into any conversation's detail view
            
            // Only initialise values if they have not been initialised
            if message.recipients == nil  {
                for recipient in message.recipients! {
                    StaticVariables.insideDetailView[recipient] = false
                }
            }
            
            self.delegate?.messageRetrieved(message)
            
        })
        
        
//        delegate?.messageRetrieved(message)
        
    }
    
    
}
