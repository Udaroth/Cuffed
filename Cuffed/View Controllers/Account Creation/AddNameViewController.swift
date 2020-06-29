//
//  AddNameViewController.swift
//  Cuffed
//
//  Created by Evan Guan on 20/12/19.
//  Copyright © 2019 Evan Guan. All rights reserved.
//

import UIKit

class AddNameViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        errorLabel.alpha = 0
        nameTextField.becomeFirstResponder()
        styleInterface()
    }
    
    func styleInterface() {
        
        Utilities.styleTextField(nameTextField)
        Utilities.styleFilledButton(nextButton)
        
    }
    
    
    @IBAction func backTapped(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        
        // Check if any errors has occured
        let error = validateFields()
        
        if error != nil {
            // If there is an error, show the error
            errorLabel.text = error
            errorLabel.alpha = 1
        } else {
            
            // Store into Constants
            let cleanedName = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Con.Account.name = cleanedName
            
            // Make error dissappear
            errorLabel.alpha = 0
            
            // Show next step
            performSegue(withIdentifier: Con.Segue.toAddBirth, sender: self)
            
        }
        
    }
    
    func validateFields() -> String? {
        
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please enter a name"
        }
        
        // Next we check if the name is valid
        
        let cleanedName = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.validateName(candidate: cleanedName) == false {
            
            return "Please enter a valid name"
        }
        
        
        return nil
    }
    

}
