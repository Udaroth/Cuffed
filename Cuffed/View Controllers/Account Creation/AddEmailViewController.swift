//
//  AddEmailViewController.swift
//  Cuffed
//
//  Created by Evan Guan on 20/12/19.
//  Copyright © 2019 Evan Guan. All rights reserved.
//

import UIKit

class AddEmailViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        errorLabel.alpha = 0
        
        emailTextField.becomeFirstResponder()
        
        styleInterface()
        
    }
    
    func styleInterface() {
        
        Utilities.styleTextField(emailTextField)
        Utilities.styleFilledButton(nextButton)
        
        
    }
    

    @IBAction func nextTapped(_ sender: UIButton) {
        
        
        // Check that the email address is valid
        let error = validateFields()
        
        if error != nil {
            // If there is an error, show the error
            errorLabel.text = error
            errorLabel.alpha = 1
        } else {
            
            // Store into Constants
            let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Con.Account.email = cleanedEmail
            
            // Make error dissappear
            errorLabel.alpha = 0
            
            // Show next step
            performSegue(withIdentifier: Con.Segue.toSetPassword, sender: self)
            
        }

        
    }
    
    
    @IBAction func backTapped(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func validateFields() -> String? {
        
        // Check if there is any input
        
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please enter an email address"
        }
        
        // Next we check if the email is valid
        
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.validateEmail(candidate: cleanedEmail) == false {
            
            return "Please enter a valid email address"
        }
        
        return nil
    }
    
}
