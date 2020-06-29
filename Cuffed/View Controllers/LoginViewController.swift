//
//  LoginViewController.swift
//  Cuffed
//
//  Created by Evan Guan on 17/12/19.
//  Copyright © 2019 Evan Guan. All rights reserved.
//

import UIKit
import FirebaseAuth


class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        errorLabel.alpha = 0
        styleInterface()
    }
    
    func styleInterface() {
        
        Utilities.styleTextField(emailTextField)
        
        Utilities.styleTextField(passwordTextField)
        
        Utilities.styleFilledButton(loginButton)
        
    }
    
    
    @IBAction func backTapped(_ sender: UIButton) {
        
         navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func loginTapped(_ sender: UIButton) {
        
        // TODO: Validate text fields
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if email == "" {
            errorLabel.text = "Please enter an email to log in with"
            errorLabel.alpha = 1
            return
        }
        
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if password == "" {
            
            errorLabel.text = "Please enter a password"
            errorLabel.alpha = 1
            return
            
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Could not sign in
                self.errorLabel.text = error?.localizedDescription
                
                self.errorLabel.alpha = 1
                
                return
                // TODO: Show error
            } else {
                
            // Sign in successful
                
                self.errorLabel.alpha = 0
                
            // Take user to home screen
            // Instantiate new Tab View controller
                let tabBarVC = self.storyboard?.instantiateViewController(identifier: Con.Storyboard.MainTabBarController)
            
                self.view.window?.rootViewController = tabBarVC
                self.view.window?.makeKeyAndVisible()

                
                
            }
            
            
        }
        
        
        
    }
    
}
