//
//  CardCompleteViewController.swift
//  Cuffed
//
//  Created by Evan Guan on 20/12/19.
//  Copyright © 2019 Evan Guan. All rights reserved.
//

import UIKit
import Firebase

class CardCompleteViewController: UIViewController {

    @IBOutlet weak var borderImage: UIImageView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var diamondsStackView: UIStackView!
    
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var gem1: UIImageView!
    
    @IBOutlet weak var gem2: UIImageView!
    
    @IBOutlet weak var gem3: UIImageView!
    
    @IBOutlet weak var gem4: UIImageView!
    
    @IBOutlet weak var gem5: UIImageView!
    
    @IBOutlet weak var gem6: UIImageView!
    
    var dbRef:DatabaseReference?
    
    var gems:[UIImageView]!
    
    var gradientLayer:CAGradientLayer?
    
    @IBOutlet weak var goButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Load all information into Card
        
        dbRef = Database.database().reference()
        
        createGradientLayer()
        
        gems = [UIImageView]()
        
        updateCard()
        
        
        // Actually maybe I'll create those methods now, and use it here. Because at this point we can display this card like any other carfds
        // Nah we'll just do it here one last time, since this one isn't in a cell
        
        styleInterface()
        
    }
    
    func styleInterface() {
        
        Utilities.styleFilledButton(goButton)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        dbRef?.removeAllObservers()
        
    }
    
    @IBAction func goPressed(_ sender: UIButton) {
        
        // Instantiate new Tab View controller
        let tabBarVC = storyboard?.instantiateViewController(identifier: Con.Storyboard.MainTabBarController)
        
        view.window?.rootViewController = tabBarVC
        view.window?.makeKeyAndVisible()
        
    }
    
    func updateCard() {
        
        // Corner Radiis
        profileImage.layer.cornerRadius = 40
        
        borderImage.layer.cornerRadius = 45
        
        setupGemArray()
        
        fetchImage()

        fetchUsername()
        
        fetchBio()
        
        fetchGems()
        
        fetchSlider()
    }
    
    func setupGemArray() {
        
        gems.append(gem1)
        gems.append(gem2)
        gems.append(gem3)
        gems.append(gem4)
        gems.append(gem5)
        gems.append(gem6)
        
    }
    
    func fetchSlider() {
            
            // Update the name label to be user's name
            guard let uid = Retrieve.retrieveUID() else { return }
            
            // Grab name of current user
            
        dbRef?.child(Con.Database.users).child(uid).child(Con.Database.border).observeSingleEvent(of: .value, with: { (snapshot) in
                
                // Check it is a String
                guard let border = snapshot.value as? Float else { return }
                
                
                self.updateRingImage(sliderValue: border)
                
            })
            
            return
            
        
        
        
    }
    
    func fetchGems() {
        
        guard let uid = Retrieve.retrieveUID() else { return }
        
        // Get snapshot of gem status
        dbRef?.child(Con.Database.users).child(uid).child(Con.Database.gems).observe(.value, with: { (snapshot) in
            
            // Put the data into a dictionary to read
            let socialDict = snapshot.value as! [String:Any]
            
            // Empty the images in the gems array
            for gem in self.gems {
                gem.image = nil
            }
            
            
            // For each of the social media
            for item in Con.socialMedia.smArray {
                // Check for gem status
                
                if socialDict[item] as! String == "yes" {
                    
                    // A gem should be displayed for this item
                    // We append this item into
                    self.appendGems(socialMedia: item)
                    
                } else {
                    
                    // No gems for this item, continue
                    
                }
                
                
            }
            
            
            
        })
        
        
    }
    
    func appendGems(socialMedia: String) {
        
        // Go through the gems array set the next nil image to given gem
        
            for gem in gems {
                
                if gem.image == nil {
                    
                    // Set the image
                    gem.image = UIImage(named: socialMedia)
                    
                    // Break out of the loop
                    return
                
                }
        
        }
    }
    
    
    func fetchImage() {
        
        guard let uid = Retrieve.retrieveUID() else { return }
        
        // Grab url of profile image
        dbRef?.child(Con.Database.users).child(uid).child(Con.Database.profileImage).observe(.value, with: { (snapshot) in
            
            // Check it is a string
            guard let urlString = snapshot.value as? String else { return }
            
            // Create Url object
            let url = URL(string: urlString)
            
            guard url != nil else { return }
            
            self.profileImage.sd_setImage(with: url) { (image, error, cacheType, url) in
                self.profileImage.image = image
                
            }
            
            
        })
    }
    
    func fetchBio() {
        
        // Update the name label to be user's name
        guard let uid = Retrieve.retrieveUID() else { return }
        
        // Grab name of current user
        
        dbRef?.child(Con.Database.users).child(uid).child(Con.Database.bio).observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Check it is a String
            guard let bio = snapshot.value as? String else { return }
            
            self.bioLabel.text = bio
            
            self.bioLabel.alpha = 1
            
        })
        
        return
        
    
        
    }
    
    func fetchUsername() {
        
        // Update the name label to be user's name
        guard let uid = Retrieve.retrieveUID() else { return }
        
        // Grab name of current user
        
        dbRef?.child(Con.Database.users).child(uid).child(Con.Database.name).observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Check it is a String
            guard let username = snapshot.value as? String else { return }
            
            self.nameLabel.text = username
            
            self.nameLabel.alpha = 1
            
        })
        
        return
    }
    
    func updateRingImage(sliderValue: Float) {
        
        // If its between 0 - 0.50
        // Caclulate ane show gradient between green and yellow
        var redTop:Float = 0.00
        var greenTop:Float = 0.00
        var blueTop:Float = 0.00
        
        var redBot:Float = 0.00
        var greenBot:Float = 0.00
        var blueBot:Float = 0.00
        
        if sliderValue <= 0.5 {
            
            let multiplier = sliderValue * 2
            // Top range
            redTop = (Con.Colors.green[0]+multiplier*Con.Colors.lowerRedDifference)
            greenTop = (Con.Colors.green[1]+multiplier*Con.Colors.lowerGreenDifference)
            blueTop = (Con.Colors.green[2]-multiplier*Con.Colors.lowerBlueDifference)
            
            // Bottom Range
            redBot = Con.Colors.yellow[0]
            greenBot = Con.Colors.yellow[1]
            blueBot = Con.Colors.yellow[2]
            
        } else {
            
            // Between yellow and orange
            let multiplier = (sliderValue - 0.5) * 2
            // Top range
            redTop = (Con.Colors.yellow[0]+multiplier*Con.Colors.higherRedDifference)
            greenTop = (Con.Colors.yellow[1]-multiplier*Con.Colors.higherGreenDifference)
            blueTop = (Con.Colors.yellow[2]-multiplier*Con.Colors.higherBlueDifference)
            
            // Bottom Range
            redBot = Con.Colors.orange[0]
            greenBot = Con.Colors.orange[1]
            blueBot = Con.Colors.orange[2]
            
        }
        
        
        let colourTop = UIColor(red: CGFloat(redTop / 255.0), green: CGFloat(greenTop / 255.0), blue: CGFloat(blueTop / 255.0), alpha: 1).cgColor
        
        let colourBottom = UIColor(red: CGFloat(redBot / 255.0), green: CGFloat(greenBot / 255.0), blue: CGFloat(blueBot / 255.0), alpha: 1).cgColor
        
        
        
        
        gradientLayer!.colors = [colourTop, colourBottom]
        
        gradientLayer!.shouldRasterize = true
        
        borderImage!.layer.addSublayer(gradientLayer!)
        
    }
    
    func createGradientLayer() {
        
        gradientLayer = CAGradientLayer()
        
        guard gradientLayer != nil else { return }
        
        gradientLayer!.frame = borderImage.bounds
        
        gradientLayer!.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer!.endPoint = CGPoint(x: 1, y: 1)
        
    }
    


}
