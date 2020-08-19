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
    
    // IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var whiteBackDropView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
// Button Outlets
    
    @IBOutlet weak var crushButton: UIButton!
    
    @IBOutlet weak var followButton: UIButton!

    @IBOutlet weak var dmButton: UIButton!
    
    @IBOutlet weak var tuneButton: UIButton!
    
    @IBOutlet weak var flipbutton: UIButton!
    
    @IBOutlet weak var otherButton: UIButton!
    // Button View Outlets
    
    
    @IBOutlet weak var crushView: UIView!
    
    @IBOutlet weak var followView: UIView!
    
    @IBOutlet weak var dmView: UIView!
    
    @IBOutlet weak var tuneView: UIView!
    
    @IBOutlet weak var flipView: UIView!
    
    @IBOutlet weak var otherView: UIView!
    
    // Button Label Outlets
    @IBOutlet weak var crushLabel: UILabel!
    
    @IBOutlet weak var tuneLabel: UILabel!
    
    @IBOutlet weak var followLabel: UILabel!
    
    // Button Image Outlets
    
    @IBOutlet weak var crushImage: UIImageView!
    
    @IBOutlet weak var tuneImage: UIImageView!
    
    @IBOutlet weak var followImage: UIImageView!
    
    // Static Variables
    var isCrush = false;
    var inTune = false;
    
    // Sublayer references
    var crushSublayer:CALayer?
    var tuneSublayer:CALayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        styleInterface()
        
//        setupGesture()
        
        fetchStatus()
        
        title = "Card"
        
        scrollView.delegate = self
        
        
        
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
                    // This card does in fact represent the user's crush
                    self.isCrush = true
                    // Make UI changes to Crush Button
                    self.crushSublayer = Utilities.styleCardBackButton(self.crushButton, Con.cardBackButtons.crush.colourTop, Con.cardBackButtons.crush.colourBottom)
                    // Set the text colour to white
                    self.crushLabel.textColor = .white
                    // Change the image to the white counter part
                    self.crushImage.image = UIImage(named: Con.Images.crushWhite)
                }

                
            } else {
                UIView.animate(withDuration: 0.2) {
                    // This card does not represent the user's crush
                    self.isCrush = false
                    // Update UI
                    _ = self.crushButton.layer.sublayers?.filter{ $0 is CAGradientLayer }.map{ $0.removeFromSuperlayer()}
                    // Set the text colour back to pink
//                    self.crushLabel.textColor = UIColor(red: CGFloat(237/255.0), green: CGFloat(107/255.0), blue: CGFloat(111/255.0), alpha: 1)
                    self.crushLabel.textColor = nil
                    // Change the image back to original one
                    self.crushImage.image = UIImage(named: Con.Images.crushNormal)
                    
                }

            }
            
            let tuneArray = snapshot!.data()![Con.Firestore.tune] as? Array<String>
            
            guard tuneArray != nil else { return }
        
            if tuneArray!.contains(self.cardUID!){
                
                UIView.animate(withDuration: 0.2) {
                    // This card is part of the tune ist
                    self.inTune = true
                    // Make UI changes to Crush Button
                    self.tuneSublayer = Utilities.styleCardBackButton(self.tuneButton, Con.cardBackButtons.ykc.colourTop, Con.cardBackButtons.ykc.colourBottom)
                    // Set the text colour to white
                    self.tuneLabel.textColor = .white
                    // Change the image to the white counter part
                    self.tuneImage.image = UIImage(named: Con.Images.tuneWhite)
                    
                    
                }

                
            } else {
                // This user was not found in the tune array
                UIView.animate(withDuration: 0.2) {
                    
                    self.inTune = false
                    
                    // Update UI
//                    self.tuneSublayer?.removeFromSuperlayer()
                    _ = self.tuneButton.layer.sublayers?.filter{ $0 is CAGradientLayer }.map{ $0.removeFromSuperlayer()}
                    // Set the text colour back to pink

                    self.tuneLabel.textColor = nil
                    
                    // Change the image back to original one
                    self.tuneImage.image = UIImage(named: Con.Images.tuneNormal)

                }

            }
        })
        
        
        
    }
    
//    func setupGesture(){
//
//        // Add Gesture recogniser
//        let panGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction(_:)))
//
//        panGestureRecognizer.edges = .left
//
//        self.view.addGestureRecognizer(panGestureRecognizer)
//
//    }
    
//    @objc func panGestureRecognizerAction(_ gesture: UIScreenEdgePanGestureRecognizer) {
//
//        let translation = gesture.translation(in: view)
//
//        view.frame.origin.x = translation.x
//
//        if gesture.state == .ended {
//
//            let velocity = gesture.velocity(in: view).x
//            let offset = translation.x
//
//
//            if velocity >= 1500 || offset > 200 {
//
//                // If the user scrolled fast or past a certain point we want to go back to previous view controller
//
//                UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
//
//                    self.view.frame.origin.x = 400
//
//
//                }) { (Bool) in
//                    self.dismiss(animated: false, completion: nil)
//                }
//
//            } else {
//
//                // We return the screen edge to its original position
//                UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
//                    self.view.frame.origin.x = 0
//                }, completion: nil)
//
//
//            }
//
//        }
//
//    }
    
    
    
    func styleInterface() {
        
        // Corner Radius and Dropshadow for white backdrop
        
//        Utilities.roundTopCorners(view: whiteBackDropView, corners: [.topLeft, .topRight], radius: 30)
        whiteBackDropView.layer.cornerRadius = 30
        
        // Database call to fetch user's name
        dbRef.child(Con.Database.users).child(cardUID!).observe(.value) { (snapshot) in
            
            let profileDict = snapshot.value as? [String:Any]
            
            guard profileDict != nil else { return }
            
            // Fetch basic data here
//            let name = profileDict![Con.Database.name] as? String
            
        }
        

        
        Utilities.newShadowCorners(mainView: crushView, shadowRadius: 5, shadowOpacity: 0.25, cornerRadius: 15)
        Utilities.newShadowCorners(mainView: tuneView, shadowRadius: 5, shadowOpacity: 0.25, cornerRadius: 15)
        Utilities.newShadowCorners(mainView: followView, shadowRadius: 5, shadowOpacity: 0.25, cornerRadius: 15)
        Utilities.newShadowCorners(mainView: dmView, shadowRadius: 5, shadowOpacity: 0.25, cornerRadius: 15)
        Utilities.newShadowCorners(mainView: flipView, shadowRadius: 5, shadowOpacity: 0.25, cornerRadius: 15)
        Utilities.newShadowCorners(mainView: otherView, shadowRadius: 5, shadowOpacity: 0.25, cornerRadius: 15)
        
//        tuneView.layer.cornerRadius = 15
//        followView.layer.cornerRadius = 15
//        dmView.layer.cornerRadius = 15
//        flipView.layer.cornerRadius = 15
//        otherView.layer.cornerRadius = 15
        
        
    
           
        
    }
    

    
    // MARK: Button animations and handling
    
    
    @IBAction func crushHighlighhted(_ sender: UIButton) {
        Animations.animateHighlight(button: crushView)
    }
    
    @IBAction func tuneHighlighted(_ sender: UIButton) {
        Animations.animateHighlight(button: tuneView)
    }
    
    @IBAction func followHighlighted(_ sender: UIButton) {
        Animations.animateHighlight(button: followView)
    }
    
    @IBAction func dmHighlighted(_ sender: UIButton) {
        Animations.animateHighlight(button: dmView)
    }
    
    @IBAction func flipHighlighted(_ sender: UIButton) {
        Animations.animateHighlight(button: flipView)
    }
    
    @IBAction func otherHighlighted(_ sender: UIButton) {
        Animations.animateHighlight(button: otherView)
    }
    
    // Handle touch cancel
    
    @IBAction func crushExit(_ sender: UIButton) {
        Animations.animateUnhighlight(button: crushView)
    }
    
    @IBAction func tuneExit(_ sender: UIButton) {
        Animations.animateUnhighlight(button: tuneView)
    }
    
    @IBAction func followExit(_ sender: UIButton) {
        Animations.animateUnhighlight(button: followView)
    }
    
    @IBAction func dmExit(_ sender: UIButton) {
        Animations.animateUnhighlight(button: dmView)
    }
    
    @IBAction func flipExit(_ sender: UIButton) {
        Animations.animateUnhighlight(button: flipView)
    }
    
    @IBAction func otherExit(_ sender: UIButton) {
        Animations.animateUnhighlight(button: otherView)
    }
    
    
    

    
    // Buttons tapped and selected

    
    @IBAction func crushTapped(_ sender: UIButton) {
        
        Animations.animateUnhighlight(button: crushView)
        
        if isCrush {
            handleRemoveCrush()
        } else {
            handleCrush()
        }

    }
    
    @IBAction func tuneTapped(_ sender: UIButton) {
        Animations.animateUnhighlight(button: tuneView)
        
        if inTune {
            handleRemoveYKC()
        } else {
            handleYKC()
        }
    }
    
    @IBAction func followTapped(_ sender: UIButton) {
        Animations.animateUnhighlight(button: followView)
    }
    
    @IBAction func dmTapped(_ sender: UIButton) {
        Animations.animateUnhighlight(button: dmView)
    }
    
    @IBAction func flipTapped(_ sender: UIButton) {
        Animations.animateUnhighlight(button: flipView)
    }
    
    @IBAction func otherTapped(_ sender: UIButton) {
        Animations.animateUnhighlight(button: otherView)
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


//extension DetailCardViewController: UIScrollViewDelegate {
//
//    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//       if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
//          navigationController?.setNavigationBarHidden(true, animated: true)
//
//       } else {
//          navigationController?.setNavigationBarHidden(false, animated: true)
//       }
//    }
//
//
//}
