//
//  AddBirthViewController.swift
//  Cuffed
//
//  Created by Evan Guan on 20/12/19.
//  Copyright © 2019 Evan Guan. All rights reserved.
//

import UIKit

class AddBirthViewController: UIViewController {

    @IBOutlet weak var birthPicker: UIDatePicker!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        errorLabel.alpha = 0
        // Do any additional setup after loading the view.
        birthPicker.datePickerMode = UIDatePicker.Mode.date
        
        let currentDate = Date()
        birthPicker.maximumDate = currentDate
        
        styleInterface()

        
    }
    
    func styleInterface() {
        
        Utilities.styleFilledButton(nextButton)
        
    }

    @IBAction func backTapped(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }

    
    @IBAction func nextTapped(_ sender: UIButton) {
        
        // No validation required because we're picking on a date picker
        // Just store the given date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        Con.Account.birth = dateFormatter.string(from: birthPicker.date)
        
        // Perform Segue to Set up complete View Controller
        performSegue(withIdentifier: Con.Segue.toSetupComplete, sender: self)
    }
    
    


}
