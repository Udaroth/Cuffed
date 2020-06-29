//
//  DetailCardViewController.swift
//  Cuffed
//
//  Created by Evan Guan on 24/2/20.
//  Copyright © 2020 Evan Guan. All rights reserved.
//

import UIKit
import Firebase


class DetailCardViewController: UIViewController {
    
    var cardUID:String?
    
    let fsRef = Firestore.firestore()
    
    let dbRef = Database.database().reference()
    
    @IBOutlet weak var topNameLabel: UILabel!
    
    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
// Button Outlets
    @IBOutlet weak var ykcButton: UIButton!
    @IBOutlet weak var crushButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    
    @IBOutlet weak var blockButton: UIButton!
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var dmButton: UIButton!
    
// Button View Outlets
    
    @IBOutlet weak var ykcView: UIView!
    
    @IBOutlet weak var crushView: UIView!
    
    @IBOutlet weak var followView: UIView!
    
    @IBOutlet weak var dmView: UIView!
    
    @IBOutlet weak var hideView: UIView!
    
    @IBOutlet weak var blockView: UIView!
    
    @IBOutlet weak var reportView: UIView!
    
    
    // Button Label Outlets
    
    @IBOutlet weak var ykcLabel: UILabel!
    
    @IBOutlet weak var crushLabel: UILabel!
    
    // Static Variables
    var isCrush = false;
    var inYKC = false;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        styleInterface()
        
        setupGesture()
        
        fetchStatus()
        
        
        
    }
    
    func fetchStatus(){
        
        let selfUID = Retrieve.retrieveUID()
        
        // Store the imageView, name, and UID if the crush / tune exists
        
         fsRef.collection(Con.Firestore.users).document(selfUID!).getDocument(completion: { (snapshot, error) in
            
            if error != nil { print(error?.localizedDescription as Any); return }
            
            if snapshot!.data() == nil {
                
                self.fsRef.collection(Con.Firestore.users).document(selfUID!).setData([Con.Firestore.crush : "", Con.Firestore.tune: [""]])
  
            }
            
            let crush = snapshot!.data()![Con.Firestore.crush] as? String
            
            if crush == self.cardUID {
                UIView.animate(withDuration: 0.2) {
                    self.crushButton.alpha = 0.5
                    self.isCrush = true;
//                    self.crushLabel.text = "Uncrush"
                }

                
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.crushButton.alpha = 1
                    self.isCrush = false
                    self.crushLabel.text = "Crush"
                }

            }
            
            let ykcArray = snapshot!.data()![Con.Firestore.tune] as? Array<String>
            
            guard ykcArray != nil else { return }
        
            if ykcArray!.contains(self.cardUID!){
                
                UIView.animate(withDuration: 0.2) {
                    self.ykcButton.alpha = 0.5
                    self.inYKC = true;
//                    self.ykcLabel.text = "Remove from  You kinda cute ;)"
                }

                
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.ykcButton.alpha = 1
                    self.inYKC = false;
                    self.ykcLabel.text = "You kinda cute ;)"
                }

            }
        })
        
        
        
    }
    
    func setupGesture(){
        
        // Add Gesture recogniser
        let panGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction(_:)))
        
        panGestureRecognizer.edges = .left
        
        self.view.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    @objc func panGestureRecognizerAction(_ gesture: UIScreenEdgePanGestureRecognizer) {
        
        let translation = gesture.translation(in: view)
        
        view.frame.origin.x = translation.x
        
        if gesture.state == .ended {
            
            let velocity = gesture.velocity(in: view).x
            let offset = translation.x
            
            
            if velocity >= 1500 || offset > 200 {
                
                // If the user scrolled fast or past a certain point we want to go back to previous view controller
                                    
                UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
                    
                    self.view.frame.origin.x = 400
                    
                    
                }) { (Bool) in
                    self.dismiss(animated: false, completion: nil)
                }

            } else {
                
                // We return the screen edge to its original position
                UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
                    self.view.frame.origin.x = 0
                }, completion: nil)

                
            }
            
        }
        
    }
    
    
    
    func styleInterface() {
        
        // Database call to fetch user's name
        dbRef.child(Con.Database.users).child(cardUID!).observe(.value) { (snapshot) in
            
            let profileDict = snapshot.value as? [String:Any]
            
            guard profileDict != nil else { return }
            
            // Fetch basic data here
            let name = profileDict![Con.Database.name] as? String
            self.topNameLabel.text = name! + "'s Card"
            
        }
        
           

                Utilities.styleCardBackButton(ykcButton, Con.cardBackButtons.ykc.colourTop, Con.cardBackButtons.ykc.colourBottom)
        
                Utilities.styleCardBackButton(crushButton, Con.cardBackButtons.crush.colourTop, Con.cardBackButtons.crush.colourBottom)
        
                Utilities.styleCardBackButton(dmButton, Con.cardBackButtons.dm.colourTop, Con.cardBackButtons.dm.colourBottom)
        
                Utilities.styleCardBackButton(followButton, Con.cardBackButtons.follow.colourTop, Con.cardBackButtons.follow.colourBottom)
        
                Utilities.styleCardBackButton(hideButton, Con.cardBackButtons.hide.colourTop, Con.cardBackButtons.hide.colourBottom)
        
                Utilities.styleCardBackButton(blockButton, Con.cardBackButtons.block.colourTop, Con.cardBackButtons.block.colourBottom)
        
                Utilities.styleCardBackButton(reportButton, Con.cardBackButtons.report.colourTop, Con.cardBackButtons.report.colourBottom)
        
        
        
        navigationView.layer.cornerRadius = 20
           
        
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            
            self.view.frame.origin.x = 400
            
            
        }) { (Bool) in
            self.dismiss(animated: false, completion: nil)
        }

        
        
    }
    
    // MARK: Button animations and handling
    
    @IBAction func ykcHighlighted(_ sender: UIButton) {
        Animations.animateHighlight(button: ykcView)
    }
    
    @IBAction func crushHighlighhted(_ sender: UIButton) {
        Animations.animateHighlight(button: crushView)
    }
    
    @IBAction func followHighlighted(_ sender: UIButton) {
        Animations.animateHighlight(button: followView)
    }
    
    @IBAction func dmHighlighted(_ sender: UIButton) {
        Animations.animateHighlight(button: dmView)
    }
    
    @IBAction func hideHighlighted(_ sender: UIButton) {
        Animations.animateHighlight(button: hideView)
    }
    
    @IBAction func blockHighlighted(_ sender: UIButton) {
        Animations.animateHighlight(button: blockView)
    }
    
    @IBAction func reportHighlighted(_ sender: UIButton) {
        Animations.animateHighlight(button: reportView)
    }
    
    // Handle touch cancel
    
    @IBAction func ykcExit(_ sender: UIButton) {
        // Animate unhighlight and do nothing
        Animations.animateUnhighlight(button: ykcView)
    }
    
    @IBAction func crushExit(_ sender: UIButton) {
        Animations.animateUnhighlight(button: crushView)
    }
    
    @IBAction func followExit(_ sender: UIButton) {
        Animations.animateUnhighlight(button: followView)
    }
    
    @IBAction func dmExit(_ sender: UIButton) {
        Animations.animateUnhighlight(button: dmView)
    }
    
    @IBAction func hideExit(_ sender: UIButton) {
        Animations.animateUnhighlight(button: hideView)
    }
    @IBAction func blockExit(_ sender: UIButton) {
        Animations.animateUnhighlight(button: blockView)
    }
    
    @IBAction func reportExit(_ sender: UIButton) {
        Animations.animateUnhighlight(button: reportView)
    }
    
    // Buttons tapped and selected
    
    @IBAction func ykcTapped(_ sender: UIButton) {
        
        Animations.animateUnhighlight(button: ykcView)
        
        if inYKC {
            
            handleRemoveYKC()
            
        } else {
            handleYKC()
        }

         
    }
    
    @IBAction func crushTapped(_ sender: UIButton) {
        
        Animations.animateUnhighlight(button: crushView)
        
        if isCrush {
            handleRemoveCrush()
        } else {
            handleCrush()
        }

    }
    
    @IBAction func followTapped(_ sender: UIButton) {
        Animations.animateUnhighlight(button: followView)
    }
    
    @IBAction func dmTapped(_ sender: UIButton) {
        Animations.animateUnhighlight(button: dmView)
    }
    
    @IBAction func hideTapped(_ sender: UIButton) {
        Animations.animateUnhighlight(button: hideView)
    }
    
    @IBAction func blockTapped(_ sender: UIButton) {
        Animations.animateUnhighlight(button: blockView)
    }
    
    @IBAction func reportTapped(_ sender: UIButton) {
        Animations.animateUnhighlight(button: reportView)
    }
    
    
    

}


extension DetailCardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        
        let cell = tableView.dequeueReusableCell(withIdentifier: Con.Cells.profileCell, for: indexPath) as! ProfileCell
        
        if cardUID == nil {
            print("No UID was parsed in")
            return cell
        }
        
        cell.delegate = self
        
        cell.resetToFront()
        
        cell.initCard(uid: cardUID!)
        
        cell.selectionStyle = .none
        
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let cell = tableView.cellForRow(at: indexPath) as? ProfileCell
        
        if cell?.isFlipped == false {
            
            cell?.trailingFlipToBack()
            cell?.isFlipped = true
            
        } else {
            // cell is flipped
            
            cell?.trailingFlipToFront()
            cell?.isFlipped = false
            
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let cell = tableView.cellForRow(at: indexPath) as? ProfileCell
        
        if cell?.isFlipped == false {
            
            cell?.leadingFlipToBack()
            cell?.isFlipped = true
            
        } else {
            // cell is flipped
            
            cell?.leadingFlipToFront()
            cell?.isFlipped = false
            
            
        }
        
        return nil
        
    }
    
    
    
    
}

extension DetailCardViewController: ProfileCellProtocols {
    func showActionSheet(_ actionSheet: UIAlertController?) {
        
    }
    
    func reloadView() {
        
    }
    
    
    
    
    
}


// Button Handling Functions
extension DetailCardViewController {
    
    func handleYKC() {
        let selfUID = Retrieve.retrieveUID()
    
        // Present action sheet with Confirm and Cancel
        // Create the alert button
        let actionSheet = UIAlertController(title: "Put this card into your YKC deck", message: "You'll be notified if your card is also in their deck", preferredStyle: .alert)
    
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
            
            // Check for an empty 'tune' slot
            self.fsRef.collection(Con.Firestore.users).document(selfUID!).getDocument { (snapshot, error) in
                
                if error != nil { return }
                
                var tuneArray = snapshot!.data()![Con.Firestore.tune] as? Array<String>
                
                if tuneArray == nil {
                    // The tune array has not yet been created
                    
                    // Create the tune array to contain the new item, and return
                    tuneArray = [self.cardUID!] as Array<String>
                    self.fsRef.collection(Con.Firestore.users).document(selfUID!).updateData([Con.Firestore.tune : tuneArray as Any])
                    
                    self.fetchStatus()
                    
                    
                    return
                    
                }
                
                print(tuneArray as Any)
                
                if tuneArray!.contains(self.cardUID!) { return }
                
                for index in 0...8 {
                    
                    if index > tuneArray!.count - 1 {
                        
                        tuneArray!.append(self.cardUID!)
                        self.fsRef.collection(Con.Firestore.users).document(selfUID!).updateData([Con.Firestore.tune : tuneArray as Any])
                        
                        break
                        
                    }

                    if tuneArray![index] == "" {
                        // If we find an empty slot in the tuneArray
                        
                        tuneArray![index] = self.cardUID!
                        // Update the array to reflect change
                        self.fsRef.collection(Con.Firestore.users).document(selfUID!).updateData([Con.Firestore.tune : tuneArray as Any])
                        
                        self.fetchStatus()
                        
                            break
                        
                    }
                    
                    
                }
                
            }
            
        
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(confirmAction)
        actionSheet.addAction(cancelAction)
        
        
        self.present(actionSheet, animated: true)
        
        
    
    
            
        }
    
    func handleCrush() {
        
        let selfUID = Retrieve.retrieveUID()
        
        // Only proceed if its not the user themselve
        if cardUID != selfUID {
            // Present action sheet with Confirm and Cancel
            // Create the action sheet
            let actionSheet = UIAlertController(title: "Make this card your Crush card", message: "You'll be notified if you're also their Crush card", preferredStyle: .alert)
        
            let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
                
                // Add said user into relevant places in the database
                self.fsRef.collection(Con.Database.users).document(selfUID!).updateData([Con.Firestore.crush : self.cardUID!])
                
                self.fetchStatus()
                
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            actionSheet.addAction(confirmAction)
            actionSheet.addAction(cancelAction)
            
            self.present(actionSheet, animated: true)
            
            
        }
    }
    
    
    func handleRemoveYKC(){
        
        // Create action sheet to remove profileUID from the Crush
        let selfUID = Retrieve.retrieveUID()
        
        // Only proceed if its not the user themselve
        if cardUID != selfUID {
            
            let actionSheet = UIAlertController(title: "Remove this card from your YKC deck", message: "You'll no longer be notified if your card is in their YKC deck", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { (action) in
                // Set the selected tune to an empty string
                self.fsRef.collection(Con.Firestore.users).document(selfUID!).getDocument { (snapshot, error) in
                    
                    if error != nil { return }
                    
                    var tuneArray = snapshot!.data()![Con.Firestore.tune] as? Array<String>
                    
                    if tuneArray != nil {
                        // if the array exists we continue
                        
                        // Iterate through the array and look for said profileUID
                        
                        for index in 0...8 {
                            
                            if tuneArray![index] == self.cardUID! {
                                // If we found the uid in the array, we set it to blank string
                                
                                tuneArray![index] = ""
                                
                                // break out of loop
                                break
                                
                            }
                            
                            
                        }
                        
                        // At this point we have the array with said profile removed
                        
                        // write it back into the firebase
                        self.fsRef.collection(Con.Firestore.users).document(selfUID!).updateData([Con.Firestore.tune : tuneArray as Any])
                        
                        self.fetchStatus()
                        
                        
                        
                    }
                    
                }
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            
            actionSheet.addAction(confirmAction)
            actionSheet.addAction(cancelAction)
            
            self.present(actionSheet, animated: true)
        }
        
        
    }
    
    
    func handleRemoveCrush(){
        
        // Create action sheet to remove profileUID from the Crush
        let selfUID = Retrieve.retrieveUID()
        
        // Only proceed if its not the user themselve
        if cardUID != selfUID {
            
            let actionSheet = UIAlertController(title: "Remove this card from Crush", message: "You'll no longer be notified if you're their Crush", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { (action) in
                // Set the crush to an empty string
                self.fsRef.collection(Con.Firestore.users).document(selfUID!).updateData([Con.Firestore.crush : "" ])
                
                self.fetchStatus()
                
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            
            actionSheet.addAction(confirmAction)
            actionSheet.addAction(cancelAction)
            
            self.present(actionSheet, animated: true)
        }
        
        
        
    }
    
    
}
