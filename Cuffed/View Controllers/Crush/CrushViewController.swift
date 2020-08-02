//
//  CrushViewController.swift
//  Cuffed
//
//  Created by Evan Guan on 29/1/20.
//  Copyright © 2020 Evan Guan. All rights reserved.
//

import UIKit
import Firebase

class CrushViewController: UIViewController {

    @IBOutlet weak var userProfileImageView: UIImageView!
    
    // Backdrop
    
    @IBOutlet weak var lightGrayBackdropView: UIView!
    
    
    // Crush components
    
    @IBOutlet weak var crushContainerView: UIView!
    
    @IBOutlet weak var orangeBackdropImageView: UIImageView!
    
    @IBOutlet weak var whiteCircularBackdropImageView: UIImageView!
    
    @IBOutlet weak var crushImageView: UIImageView!
    
    @IBOutlet weak var crushNameLabel: UILabel!
    
    @IBOutlet weak var talkCollectionView: UICollectionView!
    
    // Search related components
    
    @IBOutlet weak var searchBarView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Search VC

    var searchVC:SearchViewController?

    
    
    
    let fsRef = Firestore.firestore()
    
    let dbRef = Database.database().reference()
    
    var documents:[QueryDocumentSnapshot]?
    
    // Gem Selection Status
    var gemStatus:String?
    
    // Timestmap used to check if the search query is the latest one
    var latestFetch:String?
    
    // Search Result Selected
    var resultUID:String?
    
    // Crush UID
    var crush:String?
    
    // crushBorder
    var crushBorder:Float?
    
    // Tunes UIDs
    var tunes:[String]?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        talkCollectionView.delegate = self
        talkCollectionView.dataSource = self

        
        // Initialise the detail card
        searchVC = storyboard?.instantiateViewController(identifier: Con.Storyboard.searchVC) as? SearchViewController
        
        
        
        searchBar.delegate = self
        
        styleInterface()
        fetchCrushTuneStatus()

        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        fetchCrushTuneStatus()
        
    }
    
    func styleInterface() {
        
        setProfileImage()
        
        Utilities.styleCrushCard(orangeBackdropImageView, crushContainerView)
        
        whiteCircularBackdropImageView.layer.cornerRadius = whiteCircularBackdropImageView.frame.width/2
        
        whiteCircularBackdropImageView.backgroundColor = .white
        
        crushImageView.layer.cornerRadius = crushImageView.frame.width/2
        
        // Corner Edge for gray sheet
        Utilities.roundTopCorners(view: lightGrayBackdropView, corners: [.topLeft, .topRight], radius: 30)
        
        styleSearchBar()
        
        
    }
    
    func styleSearchBar(){
    

        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            
            textfield.backgroundColor = UIColor.white
          
        }
        
        
        Utilities.styleSearchBarView(searchBarView)
        
        
        
    }
    
    
    func setProfileImage(){
        
        let uid = Retrieve.retrieveUID()
        
        guard uid != nil else { return }
        
        dbRef.child(Con.Database.users).child(uid!).child(Con.Database.profileImage).observe(.value, with: { (snapshot) in
            
            let urlString = snapshot.value as? String
            
            if urlString != nil {
                
                let url = URL(string: urlString!)
                
                self.userProfileImageView.sd_setImage(with: url) { (image, error, cacheType, url) in
                    
                    self.userProfileImageView.image = image
                    
                }
                
            }
            
        })
        
        Utilities.addWhiteBorder(userProfileImageView)
        
        
    }
    
    func reloadCrushCell(){
        
        // Clear Crush card content
        self.crushNameLabel.text = ""
        
        self.crushImageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        self.crushImageView.image = nil
        
        // Update name and image into crush cell
        
        guard self.crush != "" && self.crush != nil else { return }
        
        dbRef.child(Con.Database.users).child(self.crush!).observe(.value) { (snapshot) in
            
            let dataDict = snapshot.value as? [String:Any]
            
            guard dataDict != nil else { return }
            
            self.crushNameLabel.text = dataDict![Con.Database.name] as? String
            
            self.crushBorder = dataDict![Con.Database.border] as? Float
             
            let urlString = dataDict![Con.Database.profileImage] as? String
            
            guard urlString != nil else { return }
            
            let url = URL(string: urlString!)
            
            self.crushImageView.sd_setImage(with: url) { (image, error, cacheType, url) in
                
                if error != nil { return }
                
                self.crushImageView.image = image
                
                
            }
                        
            
        }
        
    }
    
    func fetchCrushTuneStatus(){
        
        let selfUID = Retrieve.retrieveUID()
        
        // Store the imageView, name, and UID if the crush / tune exists
        
         fsRef.collection(Con.Firestore.users).document(selfUID!).getDocument(completion: { (snapshot, error) in
            
            if error != nil { print(error?.localizedDescription as Any); return }
            
            self.crush = snapshot!.data()?[Con.Firestore.crush] as? String
            
            self.tunes = snapshot!.data()?[Con.Firestore.tune] as? [String]
            
            // After we fetch the crush and tunes we want to reload the tune table as well as the Crush view
            
            // Make sure collectionView retrieves data correctly from tunes array
            self.talkCollectionView.reloadData()
            
            // TODO: Call function to update Crush view here
            self.reloadCrushCell()
            
        })
        
        
        
    }
    
    
    
    
    
    @IBAction func crushCardTapped(_ sender: UIButton) {
        
        // For the time being, the only reaction is to show search bar
        if self.crush == nil || self.crush == "" {
            
            searchBarTextDidBeginEditing(searchBar)
            
        } else {
            
            // Display Crush detailed View
            
            resultUID = self.crush
            
//            detailCardTableView.reloadData()
            
            // Also animate to make the detailed card to appear
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                
//                self.gradientEscapeButton.alpha = 0.3
//                self.detailCardTableView.alpha = 1
                
            }, completion: nil)
            
        }

        
    }
    



       
    
    
}


extension CrushViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Con.Cells.talkCell, for: indexPath) as! TalkCollectionViewCell
        
        // clear cell
        cell.cardUID = nil
        cell.talkImageView.image = nil
        cell.talkNameLabel.text = nil
        
        // styleCell should take in a UID in order properly display the said user
        // If no tunes array have been fetched
        if self.tunes == nil {
            
            cell.styleCell(nil)
            
            return cell
        }
        
        // If we are still within the index range we display said profile
        if indexPath.row < self.tunes!.count {
            
            cell.styleCell(self.tunes![indexPath.row])

        } else {
            // otherwise, we display empty cell
            
            cell.styleCell(nil)
            
        }

        
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! TalkCollectionViewCell
        
        if cell.cardUID == nil {
            
            //MARK: Seems like the code isn't entering this bracket
            // Might need to check whether we are initialising the cardUID to nil for each cell
            searchBarTextDidBeginEditing(searchBar)
            
        } else {
            
            // Display detailed view for said cardUID
            resultUID = cell.cardUID!
            
//            detailCardTableView.reloadData()
            
            // Also animate to make the detailed card to appear
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                
                    // TODO: Segue to the detailed card VC
//                self.gradientEscapeButton.alpha = 0.3
//                self.detailCardTableView.alpha = 1
                
            }, completion: nil)
            
            
        }
        
    }
    
    
    
    
    
}

extension CrushViewController: UISearchBarDelegate {
    

    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        // User has begun searching
        
        
        // I think here we just literally call our other controller
        if searchVC != nil {
            
//            searchVC?.cardUID = self.displayUID
            
            searchVC?.modalPresentationStyle = .overFullScreen
                        
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = .push
            transition.subtype = .fromRight
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            
            present(searchVC!, animated: false, completion: nil)
            

        }

        
//        searchBar.becomeFirstResponder()
        

        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Make database call according to the searchText

        
        let time = Utilities.fetchTime()
        
        // Only begin fetching results from database if both gemStatus and searchText are not nil
        
        // Write something to test the firestore database
        
        
        let cleanedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        if gemStatus != nil && cleanedText != "" {
            
            print("Beginning fetch for \(searchText)")
            
            
            fsRef.collection("instagramUsernames").whereField("username", arrayContains: cleanedText).getDocuments { (snapshot, error) in
                
                if let error = error {
                    
                    print("An error has occured \(error)")
                    
                } else {
                    
                    // If this is the first fetch (latestFetch == nil) or if this is the latest fetch
                    // time > latestFetch, then we update the documents and reload table
                    // Otherwise, it means this was an old query, do nothing
                    
                    if self.latestFetch == nil || time > self.latestFetch! {
                        
                        self.latestFetch = time
                        
                        //                    print("Processing Query for \(cleanedText)")
                        self.documents = snapshot!.documents
                        //                    print(self.documents)
//                        self.searchResultTableView.reloadData()
                        
                    }

                    
                }
                
            }
            
        }
        
        
        
        
    }
    
        

}

extension CrushViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1

        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
  
            
            
        let cell = tableView.dequeueReusableCell(withIdentifier: Con.Cells.profileCell, for: indexPath) as! ProfileCell
        
        cell.isFlipped = false
        
        cell.delegate = self
        
        cell.resetToFront()
        
        cell.reloadCount = 0
        
        cell.initCard(uid: resultUID)
        
        cell.selectionStyle = .none
        
        return cell
            
        
        
        
        
    }
    

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
//        if tableView != self.detailCardTableView { return nil }
        
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
        
//        if tableView != self.detailCardTableView { return nil }
        
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


extension CrushViewController: ProfileCellProtocols {
    func reloadView() {
        
        fetchCrushTuneStatus()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            
            // Make sure the search results table, gradient button, and detailed card view are all back to alpha = 0
            
//            self.searchResultTableView.alpha = 0
//            self.gradientEscapeButton.alpha = 0
//            self.detailCardTableView.alpha = 0
            // resign search bar as first responder
            self.searchBar.resignFirstResponder()
            // hide the gem stack labels
//            self.stackAndLabelView.alpha = 0
            
        }, completion: nil)
        
    }
    
    func showActionSheet(_ actionSheet: UIAlertController?) {
        
        present(actionSheet!, animated: true)
        
        
    }
    
    
}
