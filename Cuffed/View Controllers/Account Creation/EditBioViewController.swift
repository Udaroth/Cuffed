//
//  EditBioViewController.swift
//  Cuffed
//
//  Created by Evan Guan on 21/12/19.
//  Copyright © 2019 Evan Guan. All rights reserved.
//

import UIKit
import Firebase

class EditBioViewController: UIViewController {

    @IBOutlet weak var bioTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    var dbRef:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dbRef = Database.database().reference()
        
        bioTextField.becomeFirstResponder()
        
        bioTextField.delegate = self
        
        styleInterface()
    }
    
    func styleInterface() {
        
        Utilities.styleFilledButton(saveButton)
        
        Utilities.styleTextField(bioTextField)
        
    }
    
    func uploadBio() {
        
        guard bioTextField.text != nil else { return }
        
        // Grab UID
        let uid = Retrieve.retrieveUID()
        
        guard uid != nil else { return }
        
        dbRef?.child(Con.Database.users).child(uid!).child(Con.Database.bio).setValue(bioTextField.text)
        
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        
        // Upload the bio
        uploadBio()
        
        // Segue to spectrum
        performSegue(withIdentifier: Con.Segue.toSpectrum2, sender: self)
    }
    
    
    @IBAction func backTapped(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }
    


}

extension EditBioViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.count + string.count - range.length
        
        return newLength <= 256
        
    }
    
    
}
