//
//  ProfileViewController.swift
//  Cuffed
//
//  Created by Evan Guan on 15/12/19.
//  Copyright © 2019 Evan Guan. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.allowsSelection = true
        
        
        
    }
    
    
    func handleSignOut() {
        
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            self.signOut()
        }))
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func signOut() {
        
        do {
            try Auth.auth().signOut()
            
//            performSegue(withIdentifier: Con.Segue.logOutSegue, sender: self)
            // Instantiate new Tab View controller
            let loginVC = self.storyboard?.instantiateViewController(identifier: Con.Storyboard.NavigationController)
            
            self.view.window?.rootViewController = loginVC
            self.view.window?.makeKeyAndVisible()
            
//            let navController = UINavigationController(rootViewController: LandingViewController())
//            self.present(navController, animated: true, completion: nil)
            
            
        } catch {
            print("Failed to sign out")
            
        }
        
        
    }
    
    
    @IBAction func logOutTapped(_ sender: UIButton) {
        
        handleSignOut()
        
    }
    

    
    @IBAction func editTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: Con.Segue.editProfileSeg, sender: self)
        
    }
    

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        // Create a profile card cell
        let cell = tableView.dequeueReusableCell(withIdentifier: Con.Cells.profileCell, for: indexPath) as! ProfileCell
        
        // Call function to show information on cell
        
        let uid = Retrieve.retrieveUID()
        
        cell.initCard(uid: uid)
        
        cell.selectionStyle = .none
        
        cell.delegate = self
         
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let cell = tableView.cellForRow(at: indexPath) as? ProfileCell
        
        if cell?.isFlipped == false {
            
            cell?.trailingFlipToBack()
            cell?.isFlipped = true
            
        } else {
            // cell is flipped
            
            cell?.trailingFlipToFront()
            cell?.isFlipped = false
            
            
        }
        
    
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let cell = tableView.cellForRow(at: indexPath) as? ProfileCell
        
        if cell?.isFlipped == false {
            
            cell?.leadingFlipToBack()
            cell?.isFlipped = true
            
        } else {
            // cell is flipped
            
            cell?.leadingFlipToFront()
            cell?.isFlipped = false
            
            
        }
        
        
        return nil
        
    }

    

    
    
}

extension ProfileViewController: ProfileCellProtocols {
    
    func reloadView() {
        
        
    }
    
    
    func showActionSheet(_ actionSheet:UIAlertController?) {
        
        // Create the action sheet
         let actionSheet = UIAlertController(title: "Add a Photo", message: "", preferredStyle: .actionSheet)
         
         // Create actions
         if UIImagePickerController.isSourceTypeAvailable(.camera) {
             
             let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                 
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
    
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        // Dismiss image picker
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            // Got the image, now upload it
            
            Funcs.uploadExtraImage(image: selectedImage)
             
        }
        
        // Dismissed
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    
}

