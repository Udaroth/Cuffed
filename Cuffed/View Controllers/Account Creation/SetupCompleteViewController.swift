//
//  SetupCompleteViewController.swift
//  Cuffed
//
//  Created by Evan Guan on 20/12/19.
//  Copyright © 2019 Evan Guan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase

class SetupCompleteViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var completeButton: UIButton!
    
    var dbRef:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dbRef = Database.database().reference()
        errorLabel.alpha = 0
        
        spinner.alpha = 0
        
        styleInterface()
        
    }
    
    func styleInterface() {
        
        Utilities.styleFilledButton(completeButton)
    }
    
    @IBAction func completeTapped(_ sender: UIButton) {
        // Attempt to create account in Fireabse
        
        spinner.alpha = 1
        spinner.startAnimating()
        
        Auth.auth().createUser(withEmail: Con.Account.email, password: Con.Account.password) { (result, error) in
        
            
            if error != nil {
                
                self.errorLabel.text = error?.localizedDescription
                self.errorLabel.alpha = 1
                
                self.spinner.stopAnimating()
                self.spinner.alpha = 0
                
            } else {
                
                // Account with corresponding email and password has been created
                // Now store name and date of birth
                
                self.dbRef?.child("users").child(result!.user.uid).updateChildValues(["name":Con.Account.name, "dob":Con.Account.birth, "uid":result!.user.uid])
                

                
//                self.signInUser()
                
                // Remove the account creation data from the local Constants file
                Con.Account.name = ""
                Con.Account.email = ""
                Con.Account.password = ""
                Con.Account.birth = ""
                
                self.spinner.stopAnimating()
                self.spinner.alpha = 0
                
                // Perform Segue to Customize Cuff Card
                self.performSegue(withIdentifier: Con.Segue.toCustomizeCard, sender: self)
                
            }
            
            
            
            
        }
        
    }
    
    
    
    
    @IBAction func backTapped(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    


}
