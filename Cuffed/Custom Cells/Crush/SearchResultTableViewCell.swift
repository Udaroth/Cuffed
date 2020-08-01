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
    
    @IBOutlet weak var gemView: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    var dbRef:DatabaseReference?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dbRef = Database.database().reference()
        
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    func style(){
        
        Utilities.addShadowCorners(image: cellImageView, container: containerView, shadowRadius: 5, opacity: 0.3, cornerRadius: 15)
        
        Utilities.addDropShadow(view: gemView, radius: 5, opacity: 0.2)
        
        
    }
    
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
