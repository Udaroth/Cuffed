//
//  AccountCreationViewController.swift
//  Cuffed
//
//  Created by Evan Guan on 17/12/19.
//  Copyright © 2019 Evan Guan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AccountCreationViewController: UIViewController {


    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var dobTextField: UITextField!
    
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

            
        errorLabel.alpha = 0
        // Do any additional setup after loading the view.
    }
    
    // Check the fields, if they're valid return nil, if an error occurs return error message
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || dobTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || genderTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Please fill in all fields"
        }
        
//        // Check if password is secure
//        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//        
//        if Helper.isPasswordValid(cleanedPassword) == false {
//            
//            return "Please make sure your password contains at least 8 characters, a lower case letter, and a number"
//        }
        
        // Check if email is valid
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.validateEmail(candidate: cleanedEmail) == false {
            
            return "Please enter a valid E-mail address"
        }
        
        
        
        return nil
    }
    

    @IBAction func createAccountTapped(_ sender: UIButton) {
        
        // Validate fields
        let error = validateFields()
        
        if error != nil {
            // The fields do not satisfy the requirements
            
            showError(error!)
            
        } else {
            
            // Create cleaned versions of the textFields we want to store
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let dob = dobTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let gender = genderTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                
                // Check for errors
        
                if error != nil {
                    
                    // There was an error
                    
                    self.showError("Error creating user, please try again later")
                    
                    
                } else {
                    // Account created sucessfully, now store the first name and last name
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["firstName":firstName, "lastName":lastName, "uid":result!.user.uid, "dob":dob, "gender":gender]) { (error) in
                        
                        if error != nil {
                            
                            self.showError("Error uploading data, please try again later")
                        }
                        
                    }
                    
                    // Transition to tab bar screend
                    
                }
                
            }
            
        }
        

        
    }
    
    func showError(_ message:String){
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    
    

}
