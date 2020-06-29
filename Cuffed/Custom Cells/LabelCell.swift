//
//  LabelCell.swift
//  Cuffed
//
//  Created by Evan Guan on 15/12/19.
//  Copyright © 2019 Evan Guan. All rights reserved.
//

import UIKit

class LabelCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Function to update the label
    
    func updateLabel(_ name:String?){
        
        guard name != nil else {
            return
        }
        
        titleLabel.text = name!
        
        
    }
    

}
