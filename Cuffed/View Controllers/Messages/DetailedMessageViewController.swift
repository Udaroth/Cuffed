//
//  DetailedMessageViewController.swift
//  Cuffed
//
//  Created by Evan Guan on 22/1/20.
//  Copyright © 2020 Evan Guan. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class DetailedMessageViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    // IBOutlets

    @IBOutlet weak var textFieldImageView: UIImageView!
    
    @IBOutlet weak var messageTableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    // Constraint Outlets
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textFieldImageConstraint: NSLayoutConstraint!
    
    // Local variables
    
    var uid:String?
    
    var dbRef:DatabaseReference?
    
    var border:Float?
    
    var sortedMessages:[(key:String, value:Any)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dbRef = Database.database().reference()
        
        setUpInterface()
        
        // Table view set up
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        
        // Detect edge swipes
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        
        view.addGestureRecognizer(edgePan)
        
        // Handle keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(DetailedMessageViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DetailedMessageViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        messageTableView.keyboardDismissMode = .interactive

    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        
        
        if textFieldImageConstraint.constant == 10.0 && textFieldBottomConstraint.constant == 10.0 {
            
            self.textFieldBottomConstraint.constant += keyboardFrame.height
            self.textFieldImageConstraint.constant += keyboardFrame.height
            
            let indexPath = IndexPath(row: self.sortedMessages!.count - 1, section: 0)
            self.messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            
        }


        
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        
        if textFieldBottomConstraint.constant != 10.0 || textFieldImageConstraint.constant != 10.0 {
        
            self.textFieldBottomConstraint.constant = 10.0
            self.textFieldImageConstraint.constant = 10.0


        }
        
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            
            navigationController?.popViewController(animated: true)
            StaticVariables.insideDetailView[uid!] = false
            
        }
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        StaticVariables.insideDetailView[uid!] = false
        
    }
    
    @IBAction func sendTapped(_ sender: UIButton) {
        
        let senderUID = Retrieve.retrieveUID()
        
        guard senderUID != nil else { return }
        
        let recipientUID = self.uid
        
        let time = fetchTime()
        
        // Check if textField is empty
    
        let cleanedMsg = messageTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanedMsg != "" {
            
            // We want to store the text in the textField to be in the correct places in the database
            // Write into current user's chat log
            dbRef?.child(Con.Database.messages).child(senderUID!).child(Con.Database.chatLog).child(recipientUID!).child(time).updateChildValues([Con.Database.messageContent:cleanedMsg, Con.Database.senderUID:senderUID!])

           // Write into recipient user's chat log
            dbRef?.child(Con.Database.messages).child(recipientUID!).child(Con.Database.chatLog).child(senderUID!).child(time).updateChildValues([Con.Database.messageContent:cleanedMsg, Con.Database.senderUID:senderUID!])
            
            // Update the time for the latest message for both users
            dbRef?.child(Con.Database.messages).child(senderUID!).child(Con.Database.timeStamps).child(recipientUID!).setValue(time)
            
            dbRef?.child(Con.Database.messages).child(recipientUID!).child(Con.Database.timeStamps).child(senderUID!).setValue(time)
            
        }
        
        // Clear textfield
        messageTextField.text = ""
        
        
        
    }
    
    func fetchTime() -> String {
        
        let currentDate = Date()
        
        let since1970 = currentDate.timeIntervalSince1970
        
        return String(Int64(since1970 * 1000))
        
    }
    
    
    func setUpInterface() {
        
        
        guard uid != nil else { return }
        
        // MessageTextField Radius
        textFieldImageView.layer.borderWidth = 2
        textFieldImageView.layer.borderColor = UIColor.black.cgColor
        textFieldImageView.layer.cornerRadius = textFieldImageView.frame.size.height/2
        textFieldImageView.tintColor = UIColor.gray
        
        // Fetch recipient name, image, and border
        dbRef?.child(Con.Database.users).child(uid!).observe(.value, with: { (snapshot) in
            
            let userDict = snapshot.value as? [String:Any]
            
            self.nameLabel.text = userDict![Con.Database.name] as? String
            
            self.border = userDict![Con.Database.border] as? Float
            
            let url = URL(string: (userDict![Con.Database.profileImage] as? String)!)
            
            guard url != nil else { return }
            
            self.imageView.sd_setImage(with: url) { (image, error, cacheType, url) in
                
                self.imageView.image = image
                
            }
            
            Utilities.styleProfileIconBorder(self.imageView, border: self.border!, thickness: 5)
            
        })
        
        let selfUID = Retrieve.retrieveUID()
        
        guard selfUID != nil else { return }
        
        
        // Fetch chat log between the users
        dbRef?.child(Con.Database.messages).child(selfUID!).child(Con.Database.chatLog).child(uid!).observe(.value, with: { (snapshot) in
            
            let messageDict = snapshot.value as? [String:Any]
            
            guard messageDict != nil else { return }
            
            // Reorder the chatlog
            self.sortedMessages = messageDict!.sorted(by: { $0.key < $1.key })
            
            // Reload table data to read from fetched chatlog
            self.messageTableView.reloadData()
            
            let indexPath = IndexPath(row: self.sortedMessages!.count - 1, section: 0)
            
            self.messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            
        })

        
        
    }
    
    


}

extension DetailedMessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return sortedMessages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Fetch dictionary item for given indexPath.row
        let messageItem = sortedMessages![indexPath.row]
        
        // Store the content and sender tuple into detailDict
        let detailDict = messageItem.value as? [String:String]
        
        // Grab senderUID from the tuple
        let senderUID = detailDict![Con.Database.senderUID]
        
        if senderUID == self.uid {
            // This message was sent by the other user
            let cell = tableView.dequeueReusableCell(withIdentifier: Con.Cells.receivedCell, for: indexPath) as! ReceivedMessageTableViewCell
            
            cell.selectionStyle = .none
            
            let message = detailDict![Con.Database.messageContent]
            
            cell.styleCell(message!, uid: self.uid!)
            
            
            return cell
            
        } else {
            // This message was sent by the user
            let cell = tableView.dequeueReusableCell(withIdentifier: Con.Cells.sentCell, for: indexPath) as! SentMessageTableViewCell
            
            cell.selectionStyle = .none
            
            let message = detailDict![Con.Database.messageContent]
            
            cell.styleCell(message!, uid: senderUID!)
            

            
            return cell
            
            
        }
        

    }

        
    
    
}
