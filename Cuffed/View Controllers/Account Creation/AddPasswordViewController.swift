//
//  AddPasswordViewController.swift
//  Cuffed
//
//  Created by Evan Guan on 20/12/19.
//  Copyright © 2019 Evan Guan. All rights reserved.
//

import UIKit

class AddPasswordViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        errorLabel.alpha = 0
        
        passwordTextField.becomeFirstResponder()
        
        styleInterface()
    }
    
    func styleInterface() {
        
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(nextButton)
        
    }
    


    @IBAction func backTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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
            let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Con.Account.password = cleanedPassword
            
            // Make error dissappear
            errorLabel.alpha = 0
            
            // Show next step
            performSegue(withIdentifier: Con.Segue.toAddName, sender: self)
            
        }
        
    }
    
    func validateFields() -> String? {
        
        // Check if there is any input
        
        if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please create a password"
        }
        
        // Next we check if the email is valid
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.validatePassword(cleanedPassword) == false {
            
            return "Please include a minimum of 8 characters, at least 1 letter and 1 number"
        }
        
        return nil
    }

    
    


    
}


