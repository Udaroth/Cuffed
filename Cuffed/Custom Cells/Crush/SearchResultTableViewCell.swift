//
//  SearchResultTableViewCell.swift
//  Cuffed
//
//  Created by Evan Guan on 29/1/20.
//  Copyright © 2020 Evan Guan. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class SearchResultTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var gemView: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    var dbRef:DatabaseReference?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dbRef = Database.database().reference()
        
    }

    
    // style the cell with the document
    func style(documents:[QueryDocumentSnapshot]?, index:Int){
        // Add shadow and rounded corners to the cell
        Utilities.addShadowCorners(image: cellImageView, container: containerView, shadowRadius: 5, opacity: 0.3, cornerRadius: 15)
        // Add drop shadow to the gem
//        Utilities.addDropShadow(view: gemView, radius: 5, opacity: 0.2)
        
        // Update the name label using the documents retrieved
        nameLabel.text = documents![index].data()[Con.Database.name] as? String
        
        // Grab the url link from the document
        let urlString = documents![index].data()[Con.Database.profileImage] as? String
        
        // Check it is not nil
        guard urlString != nil else { return }
        
        // Use the URL function to turn that string into an url object
        let url = URL(string: urlString!)
        
        // Call the SDWebImage function to set the image
        profileImageView.sd_setImage(with: url) { (image, error, cacheType, url) in
            self.profileImageView.image = image
        }
        
        // Make the profile image circular
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        
    }
    
    // Legacy style cell function
    func styleCell(_ documents:[QueryDocumentSnapshot]?, _ index:Int) {
        
        guard documents != nil else { return }
        
        // Set cell name
        nameLabel.text = documents![index].data()[Con.Database.name] as? String
        
        let urlString = documents![index].data()[Con.Database.profileImage] as? String
        
        let borderFloat = documents![index].data()[Con.Database.border] as? Float
        
        guard urlString != nil else { return }
        
        let url = URL(string: urlString!)
        
        // Set cell image using SDWebImage
        profileImageView.sd_setImage(with: url) { (image, error, cacheType, url) in
            
            self.profileImageView.image = image
            
        }
        
        
        Utilities.styleProfileIconBorder(profileImageView, border: borderFloat ?? 0, thickness: 5)
        
        
        
        
    }
    
    
    

}
