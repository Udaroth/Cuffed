//
//  AffiliationCollectionViewCell.swift
//  Cuffed
//
//  Created by Evan Guan on 14/1/20.
//  Copyright © 2020 Evan Guan. All rights reserved.
//

import UIKit

class AffiliationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var affinityLabel: UILabel!
    
    @IBOutlet weak var affinityView: UIView!
    
    func setLabel(affinity: String){
        
        affinityLabel.text = affinity
        
    }
    
    func styleCell(){
        Utilities.newShadowCorners(mainView: affinityView, shadowRadius: 3, shadowOpacity: 0.2, cornerRadius: 10)
    }
    
}
