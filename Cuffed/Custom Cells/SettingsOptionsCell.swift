//
//  SettingsOptionsCell.swift
//  Cuffed
//
//  Created by Evan Guan on 15/12/19.
//  Copyright © 2019 Evan Guan. All rights reserved.
//

import UIKit
import Firebase

class SettingsOptionsCell: UITableViewCell {

    @IBOutlet weak var optionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if optionLabel.text == Con.Settings.logOut {
            // Log out is selected, call function in profile view controller
            
        }
        
    }
    

    


    func updateLabel(_ s:String?) {
        
        guard s != nil else {
            return
        }
        
        optionLabel.text = s!
        
    }
    
    
}
