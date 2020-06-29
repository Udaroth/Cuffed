//
//  AddDPViewController.swift
//  Cuffed
//
//  Created by Evan Guan on 20/12/19.
//  Copyright © 2019 Evan Guan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore


class AddDPViewController: UIViewController {

    
    @IBOutlet weak var nameLabel: UILabel!
    
    var dbRef:DatabaseReference?
    
    @IBOutlet weak var profileBorder: UIImageView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileBorder.layer.cornerRadius = 45
        profileImage.layer.cornerRadius = 41
        
        nameLabel.alpha = 0
        
        dbRef = Database.database().reference()
        
        fetchUsername()
        
        styleInterface()
        
    }
    
    func styleInterface() {
        
        Utilities.styleHollowButton(skipButton)
        
    }
    
    func fetchUsername() {
        
        // Update the name label to be user's name
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // Grab name of current user
        
        dbRef?.child("users").child(uid).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Check it is a String
            guard let username = snapshot.value as? String else { return }
            
            self.nameLabel.text = username
            
            self.nameLabel.alpha = 1
            
        })
        
        return
    }
    
    @IBAction func addPhotoTapped(_ sender: UIButton) {
        
        // Create the action sheet
        let actionSheet = UIAlertController(title: "Add a Profile Picture", message: "This picture will appear on the front of your card", preferredStyle: .actionSheet)
        
        // Create actions
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let cameraAction = UIAlertAction(title: "Vibe check me", style: .default) { (action) in
                
                self.showImagePicker(type: .camera)
            }
            
            actionSheet.addAction(cameraAction)
            
        }
        
        // PhotoLibrary option
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
                
                self.showImagePicker(type: .photoLibrary)
                
            }
            
            actionSheet.addAction(libraryAction)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)

        // Present action sheet
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    func showImagePicker(type:UIImagePickerController.SourceType) {
        
        // Create image picker
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = type
        imagePicker.delegate = self
        
        // Present it
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    @IBAction func skipTapped(_ sender: UIButton) {
        // Segue to the next step
        performSegue(withIdentifier: Con.Segue.toAddBio, sender: self)
        
    }
    
    
}

extension AddDPViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        // Dismiss image piker
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            // Got the image, now upload it
            
            Funcs.uploadProfileImage(image: selectedImage)
             
        }
        
        // Dismissed
        picker.dismiss(animated: true, completion: nil)
        
        // Segue to next step
        performSegue(withIdentifier: Con.Segue.toAddBio, sender: self)
        
    }
    
    
    
}
