//
//  AddBioViewController.swift
//  Cuffed
//
//  Created by Evan Guan on 20/12/19.
//  Copyright © 2019 Evan Guan. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class AddBioViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileBorder: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var dbRef:DatabaseReference?
    
    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbRef = Database.database().reference()
        
        updateCard()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        spinner.alpha = 1
        spinner.startAnimating()
        
        styleInterface()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        dbRef?.removeAllObservers()
        
    }
    
    func styleInterface() {
        
        Utilities.styleHollowButton(skipButton)
        
        
    }
    
    func updateCard() {
        
        // Corner Radiis
        profileImage.layer.cornerRadius = 40
        
        profileBorder.layer.cornerRadius = 45
        
        fetchImage()

        fetchUsername()
        
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
                
                self.spinner.alpha = 0
                self.spinner.stopAnimating()
                
            }
            
            
        })
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
    
    
    @IBAction func skipTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: Con.Segue.toSpectrum, sender: self)
        
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func addBioTapped(_ sender: UIButton) {
        
        // Open up bio editor
        performSegue(withIdentifier: Con.Segue.toEditBio, sender: self)
        
    }


}
