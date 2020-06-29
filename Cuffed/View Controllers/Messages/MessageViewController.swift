//
//  MessageViewController.swift
//  Cuffed
//
//  Created by Evan Guan on 20/1/20.
//  Copyright © 2020 Evan Guan. All rights reserved.
//

import UIKit
import Firebase

class MessageViewController: UIViewController {

    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var messageTableView: UITableView!
    
    var dbRef:DatabaseReference?
    
    var numOfMessages = 0
    
    var messageRecipients:[String]? // Array of UID
    
    var reloadCount = 0
    
    var model = MessageModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        messageTableView.delegate = self
        
        messageTableView.dataSource = self
        
        dbRef = Database.database().reference()
        
        styleInterface()
        
        // Fire off the messageModel to retrieve information from the database
        model.delegate = self
        
        model.getMessages()

        
    }
    
    
    func styleInterface() {
        
        
        let uid = Retrieve.retrieveUID()
        
        guard uid != nil else { return }
        
        dbRef?.child(Con.Database.users).child(uid!).child(Con.Database.profileImage).observe(.value, with: { (snapshot) in
            
            let urlString = snapshot.value as? String
            
            if urlString != nil {
                
                let url = URL(string: urlString!)
                
                self.iconImage.sd_setImage(with: url) { (image, error, cacheType, url) in
                    
                    self.iconImage.image = image
                    
                }
                
            }
            
        })
        
        dbRef?.child(Con.Database.users).child(uid!).child(Con.Database.border).observe(.value, with: { (snapshot) in
            
            let borderFloat = snapshot.value as? Float
            
            guard borderFloat != nil else { return }
            
            Utilities.styleProfileIconBorder(self.iconImage, border: borderFloat!, thickness: 5)
        })
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        // Detect which indexPath was selected
        let indexPath = messageTableView.indexPathForSelectedRow
        
        // Guard statement
        guard indexPath != nil else { return }
        
        // Store the tapped recipient into recipientUID
        let recipientUID = messageRecipients![indexPath!.row]
        
        // Get a reference to the detail view controller
        let detailVC = segue.destination as! DetailedMessageViewController
        
        detailVC.uid = recipientUID
        
        StaticVariables.insideDetailView[recipientUID] = true
        
        // Set the current database value for readStatus to true
        let currentUser = Retrieve.retrieveUID()
        
        guard currentUser != nil else { return }
        dbRef?.child(Con.Database.messages).child(currentUser!).child(Con.Database.readStatus).child(recipientUID).setValue("true")
        
        
    }


    
}

extension MessageViewController: MessageModelProtocol {
    
    func messageRetrieved(_ message: Messages) {
        
        // Let the values retrieved equal to local values inside the view controller so they can be accessed by the table
        if message.recipients != nil {
            self.messageRecipients = message.recipients
            self.messageTableView.reloadData()
        }
        if message.numOfConversations != nil {
            self.numOfMessages = message.numOfConversations!
        }

        
    }
    
    
    
    
    
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        return numOfMessages

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Con.Cells.messageCell, for: indexPath) as! MessageTableViewCell
        
        cell.selectionStyle = .none
        
        // If messageRecipients is nil that means initial retrieval has not occured.
        // Style empty cells
        guard messageRecipients != nil else {
            
            // Call style cell to create the graphical cell 
            cell.styleCell(nil)
            
            return cell
            
        }

        cell.styleCell(messageRecipients![indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: Con.Segue.toDetailMessages, sender: self)
        
    }
    
    
    
}

