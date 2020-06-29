//
//  LandingViewController.swift
//  Cuffed
//
//  Created by Evan Guan on 17/12/19.
//  Copyright © 2019 Evan Guan. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class LandingViewController: UIViewController {
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var fbLoginButton: UIButton!
    
    @IBOutlet weak var instaLoginButton: UIButton!
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var dbRef:DatabaseReference?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dbRef = Database.database().reference()
        
        styleInterface()
    }
    
    func styleInterface() {
        
        Utilities.styleFilledButton(loginButton)
        Utilities.styleFilledButton(fbLoginButton)
        Utilities.styleFilledButton(instaLoginButton)
        Utilities.styleHollowButton(createAccountButton)
        errorLabel.alpha = 0
        
        
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        
        
    }
    

    @IBAction func fbLoginTapped(_ sender: UIButton) {
        
        LoginManager().logIn(permissions: ["email", "public_profile"], from: self) { (result, error) in
            
            if error != nil {
                print("Login failed" , error as Any)
                return
            }
            
            self.attemptSignIn()
            
        }
    }
    
    @IBAction func instaLoginTapped(_ sender: UIButton) {
    }
    
    @IBAction func createAccountTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: Con.Segue.toCreateAccount, sender: self)
    }
    
    
    func attemptSignIn(){
        
        let accessToken = AccessToken.current
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        // Attempt authentication using credentials
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            
            if error != nil {
                
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
                
                return
            }
            
            print("Authentication Successful", user ?? "")
            
            // Check if this is the user's first time signing in
            self.dbRef?.child(Con.Database.users).child(Retrieve.retrieveUID()!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                let userDict = snapshot.value as? [String:Any]
                

                if userDict != nil {
                    // User has logged in before because database has entries with their UID
                    print("This user has logged in before, and the database has entries of their UID")
                    
                    // Segue to Main Tab Screen
                    // Instantiate new Tab View controller
                    let tabBarVC = self.storyboard?.instantiateViewController(identifier: Con.Storyboard.MainTabBarController)
                    
                    self.view.window?.rootViewController = tabBarVC
                    self.view.window?.makeKeyAndVisible()
                    
                    
                    
                } else {
                    // User has not logged in before, database has no entries of their UID
                    print("This user does not have entrires inside the database")
                    
                    // Instantiate relevant entries in the database
                
                    var dataDict:NSDictionary?
                    
                    // Graph Request to grab the required fields
                    GraphRequest(graphPath: "/me", parameters: ["fields":"picture, name, email"]).start { (connection, result, error) in
                        
                        if error != nil {
                            print("Graph Request Failed")
                            return
                        }
                        
                        // Data is returned as NSDictionary
                        dataDict = result as? NSDictionary
                        
                        guard dataDict != nil else { return }
                        
                        
                        guard dataDict!["name"] != nil else { return }
                        
                        let uid = Retrieve.retrieveUID()
                        
                        // Create the database entry
                        self.dbRef?.child(Con.Database.users).child(uid!).updateChildValues([Con.Database.name:dataDict!["name"]!])

                          // Set gem to yes to show facebook has been authenticated
                        self.dbRef?.child("users").child(uid!).child("gems").child(Con.socialMedia.facebook).setValue("yes")
                        

                        
                        
                    }
                    
                    
                    
                    // Segue to Card Customization flow
                    self.performSegue(withIdentifier: Con.Segue.toFBCustomizeCard, sender: self)
                    
                    
                    
                }
                
                
            })
            
            
            
        })
        
        
    }
    
}



