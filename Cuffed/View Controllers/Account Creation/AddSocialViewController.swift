//
//  AddSocialViewController.swift
//  Cuffed
//
//  Created by Evan Guan on 20/12/19.
//  Copyright © 2019 Evan Guan. All rights reserved.
//

import UIKit
import Firebase

class AddSocialViewController: UIViewController {
    
    var dbRef:DatabaseReference?
    
    @IBOutlet weak var fbHandle: UITextField!
    
    @IBOutlet weak var snapHandle: UITextField!
    
    @IBOutlet weak var instaHandle: UITextField!
    
    @IBOutlet weak var tiktokHandle: UITextField!
    
    @IBOutlet weak var wechatHandle: UITextField!
    
    @IBOutlet weak var youtubeHandle: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        dbRef = Database.database().reference()
        
        styleInterface()
        
    }
    
    func styleInterface() {
        
        Utilities.styleFilledButton(saveButton)
        
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }
    

    @IBAction func saveTapped(_ sender: UIButton) {
        
        // Validate and save all fields
//        upload(socialMedia: Con.socialMedia.facebook, handle: fbHandle.text)
//        upload(socialMedia: Con.socialMedia.snapchat, handle: snapHandle.text)
//        upload(socialMedia: Con.socialMedia.instagram, handle: instaHandle.text)
//        upload(socialMedia: Con.socialMedia.tiktok, handle: tiktokHandle.text)
//        upload(socialMedia: Con.socialMedia.wechat, handle: wechatHandle.text)
//        upload(socialMedia: Con.socialMedia.youtube, handle: youtubeHandle.text)
//
        // Perform Segue to card complete VC
        performSegue(withIdentifier: Con.Segue.toCardComplete, sender: self)
        
    }
    
    func upload(socialMedia: String, handle: String?) {
        
        guard dbRef != nil else { return }
        
        let uid = Retrieve.retrieveUID()
        
        guard uid != nil else { return }
        
        if handle?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            // No handle was given, upload a nil, and false for this gem
            dbRef?.child("users").child(uid!).child("social").child(socialMedia).setValue("")
            
            dbRef?.child("users").child(uid!).child("gems").child(socialMedia).setValue("no")
            
            
        } else {
            
            // Handle provided, upload handle, and true for this gem
              // No handle was given, upload a nil, and false for this gem
              dbRef?.child("users").child(uid!).child("social").child(socialMedia).setValue(handle!)
              
              dbRef?.child("users").child(uid!).child("gems").child(socialMedia).setValue("yes")
            

            
        }
        
    }
    
}
