//
//  ProfileCell.swift
//  Cuffed
//
//  Created by Evan Guan on 15/12/19.
//  Copyright © 2019 Evan Guan. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

protocol ProfileCellProtocols {
    
    func showActionSheet(_ actionSheet:UIAlertController?)
    
    func reloadView()
    
    
}


class ProfileCell: UITableViewCell {
    
    // Profile Object
    
    var profileToDisplay = Profile()
    
    // Views
    
    @IBOutlet weak var frontContainerView: UIView!
    
    @IBOutlet weak var backContainerView: UIView!
    
    @IBOutlet weak var cardFrontView: UIView!
    
    @IBOutlet weak var cardBackView: UIView!
    
    // Card Front Outlets
    
    @IBOutlet weak var dpFront: UIImageView!
    
    @IBOutlet weak var nameFront: UILabel!
    
    @IBOutlet weak var bioFront: UILabel!
    
    @IBOutlet weak var lightImageView: UIImageView!
    
    @IBOutlet weak var bottomWhiteTabView: UIView!
    
    @IBOutlet weak var IDLabel: UILabel!
    
    
    // Card Back Outlets
    
    @IBOutlet weak var cardImageBack: UIImageView!
    
    @IBOutlet weak var nameBack: UILabel!
    
    @IBOutlet weak var borderBack: UIImageView!
    
    @IBOutlet weak var dpBack: UIImageView!
    
    @IBOutlet weak var bioBack: UILabel!
    
    @IBOutlet weak var gemOneBack: UIImageView!
    
    @IBOutlet weak var gemTwoBack: UIImageView!
    
    @IBOutlet weak var gemThreeBack: UIImageView!
    
    @IBOutlet weak var gemFourBack: UIImageView!
    
    @IBOutlet weak var gemFiveBack: UIImageView!
    
    @IBOutlet weak var gemSixBack: UIImageView!
    
    var gemsBack:[UIImageView]!
    
    
    // CollectionViews
    
    @IBOutlet weak var affinityCollectionView: UICollectionView!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    // Utilities
    
    var gradientFront:CAGradientLayer?
    
    var gradientBack:CAGradientLayer?
    
    var isFlipped = false
    
    var dbRef:DatabaseReference?
    
    var numOfAffinity = 0
    
    var numOfExtraImages = 0
    
    var imageArray:[String]?
    
    var delegate:ProfileCellProtocols?
    
    var reloadCount = 0
    
    var profileUID:String?
    
    var crush:String?
    
    var tunes:[String]?
    
    let fsRef = Firestore.firestore()
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code

        
        // Create Profile instance
        gemsBack = [UIImageView]()
        
        profileToDisplay.delegate = self
        affinityCollectionView.delegate = self
        affinityCollectionView.dataSource = self
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        styleInterface()

        
        dbRef = Database.database().reference()
        
        spinner.alpha = 1
        spinner.startAnimating()
    
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    
    func reloadCollection() {
        
        imageCollectionView.reloadData()
        affinityCollectionView.reloadData()
        
    }
    
    func fetchData() {
    dbRef?.child(Con.Database.users).child(profileUID!).child(Con.Database.extraImages).observe(.value) { (snapshot) in
       
       print("Inside database call")
       
       // Store all the extra images and their URL into imagesDict
       let imagesDict = snapshot.value as? [String:String]
       
       // Store the number of items
       guard imagesDict != nil else {
           self.numOfExtraImages = 0
           return
           
       }
       
       self.numOfExtraImages = imagesDict!.count
       
       // Store the URL of all the images into static array
       self.imageArray = Array(imagesDict!.values)

       self.reloadCollection()
       
       }
        

        
        
    }
    
    func styleInterface() {
        
        // Card front radius
        Utilities.roundTopCorners(view: dpFront, corners: [.topLeft, .topRight], radius: 20)
        Utilities.addDropShadow(view: frontContainerView, radius: 10, opacity: 0.3)
        
        // Card back radius
        Utilities.addShadowCorners(image: cardImageBack, container: backContainerView, shadowRadius: 10, opacity: 0.3, cornerRadius: 20)
        
        // Circular dp radius
        dpBack.layer.cornerRadius = dpBack.frame.size.width/2
        borderBack.layer.cornerRadius = borderBack.frame.size.width/2
        
        // Set up light image view
        lightImageView.layer.cornerRadius = lightImageView.frame.size.width/2
        // Initialise white drop shadow
        lightImageView.layer.shadowColor = .init(srgbRed: 255, green: 255, blue: 255, alpha: 1)
        lightImageView.layer.shadowOpacity = 0.5
        lightImageView.layer.shadowRadius = 10
        
        // Apply dropshadow to IDLabel
        IDLabel.layer.shadowOpacity = 0.3
        IDLabel.layer.shadowRadius = 5
        
        // Bottom Corner radius for the white tab
        Utilities.roundTopCorners(view: bottomWhiteTabView, corners: [.bottomLeft, .bottomRight], radius: cardImageBack.frame.size.width/24)
        
        // Dropshadow for the gems
        for image in gemsBack {
            Utilities.addDropShadow(view: image, radius: 3, opacity: 0.2)
        }
    
        
    }
    
    // Takes in a uid to create the profile for said user
    func initCard(uid: String?) {
        
        
        guard uid != nil  else { return }
        
        profileUID = uid
        
        // Retrieve all data
//        self.profileToDisplay.retrieveData(uid: uid!)
        fetchData()
        fetchCrushTuneStatus()

        // Set up observer to retrieve data again everytime a change is detected
        dbRef?.child(Con.Database.users).child(profileUID!).observe(.value, with: { (snapshot) in
            
            self.profileToDisplay.retrieveData(uid: self.profileUID!)
            self.reloadCount = 0
            self.reloadCollection()

            
        })
        
        // Initialise gems array and Append gems
        
        setupGemArray()
        
        // Initialise gradient utilities
        gradientFront = CAGradientLayer()
        gradientBack = CAGradientLayer()
        
        guard gradientFront != nil else { return }
        guard gradientBack != nil else { return }
        
        gradientFront!.frame = lightImageView.bounds
        gradientBack!.frame = borderBack.bounds
        
        gradientFront!.startPoint = CGPoint(x: 0, y: 0)
        gradientFront!.endPoint = CGPoint(x: 1, y: 1)
        gradientBack!.startPoint = CGPoint(x: 0, y: 0)
        gradientBack!.endPoint = CGPoint(x: 1, y: 1)
        
        
    }
    
    func fetchCrushTuneStatus(){
        
        let selfUID = Retrieve.retrieveUID()
        
        // Store the imageView, name, and UID if the crush / tune exists
        
         fsRef.collection(Con.Firestore.users).document(selfUID!).getDocument(completion: { (snapshot, error) in
            
            if error != nil { print(error?.localizedDescription as Any); return }
            
            if snapshot!.data() == nil {
                
                self.fsRef.collection(Con.Firestore.users).document(selfUID!).setData([Con.Firestore.crush : "", Con.Firestore.tune: [""]])

                
            }
            
            self.crush = snapshot!.data()![Con.Firestore.crush] as? String
            
            self.tunes = snapshot!.data()![Con.Firestore.tune] as? [String]
        
            
        })
        
        
        
    }
    
    func setupGemArray() {
        
        gemsBack.append(gemOneBack)
        gemsBack.append(gemTwoBack)
        gemsBack.append(gemThreeBack)
        gemsBack.append(gemFourBack)
        gemsBack.append(gemFiveBack)
        gemsBack.append(gemSixBack)
        
        
    }
    
    func leadingFlipToBack() {
        
        UIView.transition(from: cardFrontView, to: cardBackView, duration: 0.4, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        
    }
    
    func trailingFlipToBack() {
        
        UIView.transition(from: cardFrontView, to: cardBackView, duration: 0.4, options: [.showHideTransitionViews, .transitionFlipFromRight], completion: nil)
        
    }
    
    func leadingFlipToFront() {
        
        UIView.transition(from: cardBackView, to: cardFrontView, duration: 0.4, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        
    }
    
    func trailingFlipToFront() {
        
        UIView.transition(from: cardBackView, to: cardFrontView, duration: 0.4, options:[.showHideTransitionViews, .transitionFlipFromRight], completion: nil)
        
    }
    
    func resetToFront(){
        
        UIView.transition(from: cardBackView, to: cardFrontView, duration: 0, options: [.showHideTransitionViews, .transitionFlipFromRight], completion: nil)
        
    }
    

    @IBAction func uncrushTapped(_ sender: UIButton) {
        
        // Create action sheet to remove profileUID from the Crush
        let selfUID = Retrieve.retrieveUID()
        
        // Only proceed if its not the user themselve
        if profileUID != selfUID {
            
            let actionSheet = UIAlertController(title: "Remove selected user as Crush", message: "", preferredStyle: .actionSheet)
            
            let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { (action) in
                // Set the crush to an empty string
                self.fsRef.collection(Con.Firestore.users).document(selfUID!).updateData([Con.Firestore.crush : "" ])
                
                self.fetchCrushTuneStatus()
                
                self.delegate?.reloadView()
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            
            actionSheet.addAction(confirmAction)
            actionSheet.addAction(cancelAction)
            
            delegate?.showActionSheet(actionSheet)
        }
        
        
    }
    
    @IBAction func cuffTapped(_ sender: UIButton) {
        
        let selfUID = Retrieve.retrieveUID()
        
        // Only proceed if its not the user themselve
        if profileUID != selfUID {
            // Present action sheet with Confirm and Cancel
            // Create the action sheet
            let actionSheet = UIAlertController(title: "Add the selected user as your Crush", message: "", preferredStyle: .actionSheet)
        
            let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
                
                // Add said user into relevant places in the database
                self.fsRef.collection(Con.Database.users).document(selfUID!).updateData([Con.Firestore.crush : self.profileUID!])
                
                self.fetchCrushTuneStatus()
                
                self.delegate?.reloadView()
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            actionSheet.addAction(confirmAction)
            actionSheet.addAction(cancelAction)
            
            delegate?.showActionSheet(actionSheet)
            
            
        }
        
        
    }
    

    @IBAction func untuneTapped(_ sender: UIButton) {
        
        // Create action sheet to remove profileUID from the Crush
        let selfUID = Retrieve.retrieveUID()
        
        // Only proceed if its not the user themselve
        if profileUID != selfUID {
            
            let actionSheet = UIAlertController(title: "Remove selected user as Tune", message: "", preferredStyle: .actionSheet)
            
            let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { (action) in
                // Set the selected tune to an empty string
                self.fsRef.collection(Con.Firestore.users).document(selfUID!).getDocument { (snapshot, error) in
                    
                    if error != nil { return }
                    
                    var tuneArray = snapshot!.data()![Con.Firestore.tune] as? Array<String>
                    
                    if tuneArray != nil {
                        // if the array exists we continue
                        
                        // Iterate through the array and look for said profileUID
                        
                        for index in 0...8 {
                            
                            if tuneArray![index] == self.profileUID! {
                                // If we found the uid in the array, we set it to blank string
                                
                                tuneArray![index] = ""
                                
                                // break out of loop
                                break
                                
                            }
                            
                            
                        }
                        
                        // At this point we have the array with said profile removed
                        
                        // write it back into the firebase
                        self.fsRef.collection(Con.Firestore.users).document(selfUID!).updateData([Con.Firestore.tune : tuneArray as Any])
                        
                        self.fetchCrushTuneStatus()
                        
                        self.delegate?.reloadView()
                        
                        
                        
                    }
                    
                }
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            
            actionSheet.addAction(confirmAction)
            actionSheet.addAction(cancelAction)
            
            delegate?.showActionSheet(actionSheet)
        }
        
    }
    
    @IBAction func talkTapped(_ sender: UIButton) {
        
        let selfUID = Retrieve.retrieveUID()
        
        // Only proceed if its not the user themselve
        if profileUID != selfUID {
            // Present action sheet with Confirm and Cancel
            // Create the! action sheet
            let actionSheet = UIAlertController(title: "Add the selected user as your Tune", message: "Add the selected user as your Tune", preferredStyle: .actionSheet)
        
            let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
                
                // Check for an empty 'tune' slot

                self.fsRef.collection(Con.Firestore.users).document(selfUID!).getDocument { (snapshot, error) in
                    
                    if error != nil { return }
                    
                    var tuneArray = snapshot!.data()![Con.Firestore.tune] as? Array<String>
                    
                    if tuneArray == nil {
                        // The tune array has not yet been created
                        
                        // Create the tune array to contain the new item, and return
                        tuneArray = [self.profileUID!] as Array<String>
                        self.fsRef.collection(Con.Firestore.users).document(selfUID!).updateData([Con.Firestore.tune : tuneArray as Any])
                        
                         self.fetchCrushTuneStatus()
                         
                         self.delegate?.reloadView()
                        
                        return
                        
                    }
                    
                    print(tuneArray as Any)
                    
                    if tuneArray!.contains(self.profileUID!) { return }
                    
                    for index in 0...8 {
                        
                        if index > tuneArray!.count - 1 {
                            
                            tuneArray!.append(self.profileUID!)
                            self.fsRef.collection(Con.Firestore.users).document(selfUID!).updateData([Con.Firestore.tune : tuneArray as Any])
                            
                            break
                            
                        }

                        if tuneArray![index] == "" {
                            // If we find an empty slot in the tuneArray
                            
                            tuneArray![index] = self.profileUID!
                            // Update the array to reflect change
                            self.fsRef.collection(Con.Firestore.users).document(selfUID!).updateData([Con.Firestore.tune : tuneArray as Any])
                            
                                self.fetchCrushTuneStatus()
                            
                                self.delegate?.reloadView()
                                
                                break
                            
                        }
                        
                        
                    }
                    
                }
                
                
                // Add said user into relevant places in the database
                
                
//                self.fsRef.collection(Con.Firestore.users).document(selfUID!).setData(["tune": self.profileUID!])
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            actionSheet.addAction(confirmAction)
            actionSheet.addAction(cancelAction)
            
            
            delegate?.showActionSheet(actionSheet)
            
            
        }
        
        
    }
    
    
    
    
}


extension ProfileCell: ProfileProtocol {
    func profileRetrieved() {
        
        // Retrieval from database has finished
        // Update names
        nameFront.text = profileToDisplay.name
        nameBack.text = profileToDisplay.name
        
        // Update bio
        bioFront.text = profileToDisplay.bio
//        bioBack.text = profileToDisplay.bio
        
        // Update front and back DP
        guard profileToDisplay.profileImage != nil else { return }

        let url = URL(string: profileToDisplay.profileImage!)
        
        guard url != nil else { return }

        dpFront.sd_setImage(with: url, completed: { (image, error, cacheType, url) in
            
            if error != nil {
                print(error?.localizedDescription as Any)
            }
            
            self.dpFront.image = image
            self.dpBack.image = image
            
        })
        
        // Update gems into profile
        guard profileToDisplay.gems != nil else { print("No Gems to display"); return }
        
        // Clear gems front and back
        for imgView in gemsBack {
            imgView.image = nil
        }
        
        // For every gem item we're going to display
        for gem in profileToDisplay.gems! {
            
            
            if gem == Con.socialMedia.facebook {
                gemsBack[0].image = UIImage(named: Con.socialMedia.facebook)
            }
            if gem == Con.socialMedia.snapchat {
                gemsBack[1].image = UIImage(named: Con.socialMedia.snapchat)
            }
            if gem == Con.socialMedia.instagram {
                gemsBack[2].image = UIImage(named: Con.socialMedia.instagram)
            }
            if gem == Con.socialMedia.tiktok {
                gemsBack[3].image = UIImage(named: Con.socialMedia.tiktok)
            }
            if gem == Con.socialMedia.youtube {
                gemsBack[4].image = UIImage(named: Con.socialMedia.youtube)
            }
            if gem == Con.socialMedia.wechat {
                gemsBack[5].image = UIImage(named: Con.socialMedia.wechat)
            }

            
            
        }
        
        // Fill out the remaining gem slots with Gemholder image

        
        for imgView in gemsBack {
            
            if imgView.image == nil {
                imgView.image = UIImage(named: Con.Images.gemHolder)
            }
        }
        
        // Set gradient for border
        setGradient()
        
        // Set up complete, remove spinner
        spinner.stopAnimating()
        spinner.alpha = 0
        
    }
    
    func setGradient() {
        
        // If its between 0 - 0.50
        // Caclulate ane show gradient between green and yellow
        var redTop:Float = 0.00
        var greenTop:Float = 0.00
        var blueTop:Float = 0.00
        
        var redBot:Float = 0.00
        var greenBot:Float = 0.00
        var blueBot:Float = 0.00
        
        guard profileToDisplay.border != nil else { return }
        
        if profileToDisplay.border! <= 0.5 {
            // The decimal is between green and yellow
            
            let multiplier = profileToDisplay.border! * 2
            
            // Calculate center RGB using multiplier
            let redCenter = Con.Colors.green[0] + multiplier*Con.Colors.lowerRedDifference
            let greenCenter = Con.Colors.yellow[1] + multiplier*Con.Colors.lowerGreenDifference
            let blueCenter = Con.Colors.yellow[2] + multiplier*Con.Colors.lowerBlueDifference
            
            // Call function which increments the RGB value towards Green for top
            redTop = Utilities.calculateGradient(redCenter, Con.Colors.green[0])
            greenTop = Utilities.calculateGradient(greenCenter, Con.Colors.green[1])
            blueTop = Utilities.calculateGradient(blueCenter, Con.Colors.green[2])
            
            // Call function which increments the RGB values towards yellow for bottom
            redBot = Utilities.calculateGradient(redCenter, Con.Colors.yellow[0])
            greenBot = Utilities.calculateGradient(greenCenter, Con.Colors.yellow[1])
            blueBot = Utilities.calculateGradient(blueCenter, Con.Colors.yellow[2])
            
        } else {
            
            // Between yellow and orange
            let multiplier = (profileToDisplay.border! - 0.5) * 2

            // Calculate center RGB using multiplier
            let redCenter = Con.Colors.orange[0] + multiplier*Con.Colors.higherRedDifference
            let greenCenter = Con.Colors.orange[1] + multiplier*Con.Colors.higherGreenDifference
            let blueCenter = Con.Colors.yellow[2] + multiplier*Con.Colors.higherBlueDifference
            
            // Call function which increments the RGB value towards Green for top
            redTop = Utilities.calculateGradient(redCenter, Con.Colors.yellow[0])
            greenTop = Utilities.calculateGradient(greenCenter, Con.Colors.yellow[1])
            blueTop = Utilities.calculateGradient(blueCenter, Con.Colors.yellow[2])
            
            // Call function which increments the RGB values towards yellow for bottom
            redBot = Utilities.calculateGradient(redCenter, Con.Colors.orange[0])
            greenBot = Utilities.calculateGradient(greenCenter, Con.Colors.orange[1])
            blueBot = Utilities.calculateGradient(blueCenter, Con.Colors.orange[2])
            
        }
        
        
        let colourTop = UIColor(red: CGFloat(redTop / 255.0), green: CGFloat(greenTop / 255.0), blue: CGFloat(blueTop / 255.0), alpha: 1).cgColor
        
        let colourBottom = UIColor(red: CGFloat(redBot / 255.0), green: CGFloat(greenBot / 255.0), blue: CGFloat(blueBot / 255.0), alpha: 1).cgColor
        
        
        
        
        gradientFront!.colors = [colourTop, colourBottom]
        gradientBack!.colors = [colourTop, colourBottom]
        
        gradientFront!.shouldRasterize = true
        gradientBack!.shouldRasterize = true
        
        borderBack!.layer.addSublayer(gradientBack!)
        lightImageView.layer.addSublayer(gradientFront!)
        
        
    }
    
    
}


extension ProfileCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        let selfUID = Retrieve.retrieveUID()
        
        guard selfUID != nil else { return 0 }
        guard profileUID != nil else { return 0}

        // Check whichh collection view we are setting up for
        if collectionView == self.affinityCollectionView {

            dbRef?.child(Con.Database.users).child(profileUID!).child(Con.Database.affinity).observeSingleEvent(of: .value, with: { (snapshot:DataSnapshot) in
                
                
                // Store the snapshot into a dictinoary
                guard let affinityDict = snapshot.value as? [String:String] else {
                    print("Error fetching affinity")
                    return
                }
                
                // The number of items in the dict equal to number of Affinitys
                self.numOfAffinity = affinityDict.count
                
            })
            
            // The increment of 1 is for the addAffinity Cell
            if selfUID == profileUID {
                return self.numOfAffinity + 1
            } else {
                // It's not the user's own profile
                if self.numOfAffinity == 0 {
                    return 1
                } else {
                    return self.numOfAffinity
                }

            }

            
        } else {
            // Setting up image collection view
                        
            dbRef?.child(Con.Database.users).child(profileUID!).child(Con.Database.extraImages).observeSingleEvent(of: .value, with: { (snapshot:DataSnapshot) in
                
                guard let imagesDict = snapshot.value as? [String:String] else { return }
                
                self.numOfExtraImages = imagesDict.count
                
            })
            
            // Extra cell for adding new images
            if selfUID == profileUID {
                return self.numOfExtraImages + 1
            } else {
                // If it's not the user's own profile
                if self.numOfExtraImages == 0 {
                    return 1
                } else {
                    return self.numOfExtraImages
                }

            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let selfUID = Retrieve.retrieveUID()
        
        guard profileUID != nil else { return collectionView.dequeueReusableCell(withReuseIdentifier: Con.Cells.affinityCell, for: indexPath)}
        
        // If we're setting up the affinity collection view
        if collectionView == self.affinityCollectionView {
            // If we've reached the addAffinity cell, create corresponding cell
            if indexPath.row >= numOfAffinity && selfUID == profileUID {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Con.Cells.addAffinityCell, for: indexPath) as! AddAffinityCollectionViewCell
                
                cell.layer.cornerRadius = 10
                
                return cell
                
                
            } else if self.numOfAffinity == 0 {
                // Create a placeholder cell here
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Con.Cells.affinityCell, for: indexPath) as! AffiliationCollectionViewCell
                
                cell.setLabel(affinity: "No Affiliations")
                
                cell.layer.cornerRadius = 10
                
//                Utilities.newShadowCorners(mainView: cell as UIView, shadowRadius: 3, shadowOpacity: 0.2, cornerRadius: 10)
                
                return cell
                
            } else {
                
                // Create affinity cell
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Con.Cells.affinityCell, for: indexPath) as! AffiliationCollectionViewCell
               
                    // Get access to affinity for this user in the database
                dbRef?.child(Con.Database.users).child(profileUID!).child(Con.Database.affinity).observeSingleEvent(of: .value, with: { (snapshot:DataSnapshot) in
                    
                    // Store the snapshot into a dictinoary
                    let affinityDict = snapshot.value as! [Int:String]
                    
                    // Set the label text of this affinity cell
                    cell.setLabel(affinity: affinityDict[indexPath.row]!)
                    
                    
                })
                
                cell.layer.cornerRadius = 10
                

                return cell
                
            }
            
        } else {
            // Else we are setting up the image collection view
            // Now check if we're creating an add image cell or show image cell
                                        
            
            
            if indexPath.row >= numOfExtraImages && selfUID == profileUID {
                // Add image cell
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Con.Cells.addImageCell, for: indexPath) as! AddImageCollectionViewCell
                
                cell.layer.cornerRadius = 15
                
                return cell
            } else if self.numOfExtraImages == 0 {
                
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Con.Cells.imageCell, for: indexPath) as! ImageCollectionViewCell
                
                cell.layer.cornerRadius = 15
                
                // Create placeholder image asset and set image here
                
                return cell
                
            }  else {
                           // Show image cell
                           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Con.Cells.imageCell, for: indexPath) as! ImageCollectionViewCell
                           
                           cell.layer.cornerRadius = 15
                           
                           guard imageArray != nil else { return cell}
                           
                           // Access the URL of the image
                           cell.setImage(urlString: imageArray![indexPath.row])
                           
                           
                           return cell
                       }




        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selfUID = Retrieve.retrieveUID()
        
        if collectionView == self.affinityCollectionView {
            // Affinity cells selected
            
        } else {
            // Image cells selected
            
            // Now check if it is a show image cell or add image cell that was selected
            
            if indexPath.row >= numOfExtraImages && selfUID == profileUID{
                // 'Add image' is selected
                
                // Create action sheet
                if let delegate = self.delegate {
                    
                    delegate.showActionSheet(nil)
                    
                }


                
            }
            
            
            
            
        }
        
        
    }
    

    

    
    
    
    
}
