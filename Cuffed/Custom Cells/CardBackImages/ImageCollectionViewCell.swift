//
//  ImageCollectionViewCell.swift
//  Cuffed
//
//  Created by Evan Guan on 16/1/20.
//  Copyright © 2020 Evan Guan. All rights reserved.
//

import UIKit
import SDWebImage

class ImageCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    func setImage(urlString: String){
        
        
        let url = URL(string: urlString)
        
        guard url != nil else { return }
        
        imageView.sd_setImage(with: url) { (image, error, cacheType, url) in
            
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            
            self.imageView.image = image
            
        }
        
        
    }
    
}
