//
//  EditProfileViewController.swift
//  Cuffed
//
//  Created by Evan Guan on 10/1/20.
//  Copyright © 2020 Evan Guan. All rights reserved.
//

import UIKit
import Firebase


class EditProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var borderImageView: UIImageView!
    
    @IBOutlet weak var spectrumImageView: UIImageView!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var descTextField: UITextField!
    
    @IBOutlet weak var fbUsernameTextField: UITextField!
    
    @IBOutlet weak var instaUsernameTextField: UITextField!
    
    @IBOutlet weak var snapchatUsernameTextField: UITextField!
    
    @IBOutlet weak var tiktokUsernameTextField: UITextField!
    
    @IBOutlet weak var youtubeUsernameTextField: UITextField!
    
    @IBOutlet weak var wechatUsernameTextField: UITextField!
    
    var currentProfile = Profile()
    
    var gradientLayer:CAGradientLayer?
    
    var dbRef:DatabaseReference?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currentProfile.delegate = self
        dbRef = Database.database().reference()
        updateFields()
        styleInterface()
        
        
    }
    
    func styleInterface() {
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        borderImageView.layer.cornerRadius = borderImageView.frame.size.width/2
        spectrumImageView.layer.cornerRadius = spectrumImageView.frame.size.height/2
        
        Utilities.styleTextField(nameTextField)
        Utilities.styleTextField(descTextField)
        Utilities.styleTextField(snapchatUsernameTextField)
        Utilities.styleTextField(fbUsernameTextField)
        Utilities.styleTextField(instaUsernameTextField)
        Utilities.styleTextField(tiktokUsernameTextField)
        Utilities.styleTextField(wechatUsernameTextField)
        Utilities.styleTextField(youtubeUsernameTextField)
        
    }
    
    func updateFields() {
    
        // Fetch current user's UID
        
        let uid = Retrieve.retrieveUID()
        
        guard uid != nil else {
            print("Error retrieving UID")
            return
        }
        
        // Prepare the gradient layer
        // Initialise gradient utilities
        gradientLayer = CAGradientLayer()
        
        guard gradientLayer != nil else { return }
        
        gradientLayer!.frame = borderImageView.bounds
        
        gradientLayer!.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer!.endPoint = CGPoint(x: 1, y: 1)
        
        // Call retrieve data function
        currentProfile.retrieveData(uid: uid)
        
        // The retrieve data function will call the delegate function which is where we will handle the part where we update the information.
        
        
        
    }
    
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        
        let sliderValue = slider.value
        
        updateRingImage(sliderValue: sliderValue)
        
    }
    

    @IBAction func cancelTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        
        // Store all fields back into the database
        
        // Grab UID
        let uid = Retrieve.retrieveUID()
        
        guard uid != nil else { return }
        
        // Store the name
        dbRef?.child(Con.Database.users).child(uid!).child(Con.Database.name).setValue(nameTextField.text)
        
        // Store the description
        dbRef?.child(Con.Database.users).child(uid!).child(Con.Database.bio).setValue(descTextField.text)
        
        // Store the border
        dbRef?.child(Con.Database.users).child(uid!).child(Con.Database.border).setValue(slider.value)
        
        // Store the social media handles and relevant gems
        dbRef?.child(Con.Database.users).child(uid!).child(Con.Database.social).child(Con.socialMedia.facebook).setValue(fbUsernameTextField.text)
        dbRef?.child(Con.Database.users).child(uid!).child(Con.Database.social).child(Con.socialMedia.instagram).setValue(instaUsernameTextField.text)
        dbRef?.child(Con.Database.users).child(uid!).child(Con.Database.social).child(Con.socialMedia.snapchat).setValue(snapchatUsernameTextField.text)
        dbRef?.child(Con.Database.users).child(uid!).child(Con.Database.social).child(Con.socialMedia.tiktok).setValue(tiktokUsernameTextField.text)
        dbRef?.child(Con.Database.users).child(uid!).child(Con.Database.social).child(Con.socialMedia.wechat).setValue(wechatUsernameTextField.text)
        dbRef?.child(Con.Database.users).child(uid!).child(Con.Database.social).child(Con.socialMedia.youtube).setValue(youtubeUsernameTextField.text)
        
        
        updateGemStatus(textfield: fbUsernameTextField, media: Con.socialMedia.facebook)
        updateGemStatus(textfield: instaUsernameTextField, media: Con.socialMedia.instagram)
        updateGemStatus(textfield: snapchatUsernameTextField, media: Con.socialMedia.snapchat)
        updateGemStatus(textfield: tiktokUsernameTextField, media: Con.socialMedia.tiktok)
        updateGemStatus(textfield: wechatUsernameTextField, media: Con.socialMedia.wechat)
        updateGemStatus(textfield: youtubeUsernameTextField, media: Con.socialMedia.youtube)
        
        // Get profile view controller to reload data
        
        // dismiss this controller
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func updateGemStatus(textfield: UITextField, media: String) {
        
        let uid = Retrieve.retrieveUID()
        
        if textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            dbRef?.child(Con.Database.users).child(uid!).child(Con.Database.gems).child(media).setValue(Con.Database.no)
            
        } else {
            dbRef?.child(Con.Database.users).child(uid!).child(Con.Database.gems).child(media).setValue(Con.Database.yes)
            
        }
        
    }
    
    func updateRingImage(sliderValue: Float) {
        
        // If its between 0 - 0.50
        // Caclulate ane show gradient between green and yellow
        var redTop:Float = 0.00
        var greenTop:Float = 0.00
        var blueTop:Float = 0.00
        
        var redBot:Float = 0.00
        var greenBot:Float = 0.00
        var blueBot:Float = 0.00
        
        if sliderValue <= 0.5 {
            
            let multiplier = sliderValue * 2
            // Top range
            redTop = (Con.Colors.green[0]+multiplier*Con.Colors.lowerRedDifference)
            greenTop = (Con.Colors.green[1]+multiplier*Con.Colors.lowerGreenDifference)
            blueTop = (Con.Colors.green[2]-multiplier*Con.Colors.lowerBlueDifference)
            
            // Bottom Range
            redBot = Con.Colors.yellow[0]
            greenBot = Con.Colors.yellow[1]
            blueBot = Con.Colors.yellow[2]
            
        } else {
            
            // Between yellow and orange
            let multiplier = (sliderValue - 0.5) * 2
            // Top range
            redTop = (Con.Colors.yellow[0]+multiplier*Con.Colors.higherRedDifference)
            greenTop = (Con.Colors.yellow[1]-multiplier*Con.Colors.higherGreenDifference)
            blueTop = (Con.Colors.yellow[2]-multiplier*Con.Colors.higherBlueDifference)
            
            // Bottom Range
            redBot = Con.Colors.orange[0]
            greenBot = Con.Colors.orange[1]
            blueBot = Con.Colors.orange[2]
            
        }
        
        
        let colourTop = UIColor(red: CGFloat(redTop / 255.0), green: CGFloat(greenTop / 255.0), blue: CGFloat(blueTop / 255.0), alpha: 1).cgColor
        
        let colourBottom = UIColor(red: CGFloat(redBot / 255.0), green: CGFloat(greenBot / 255.0), blue: CGFloat(blueBot / 255.0), alpha: 1).cgColor
        
        
        
        
        gradientLayer!.colors = [colourTop, colourBottom]
        
        gradientLayer!.shouldRasterize = true
        
        borderImageView!.layer.addSublayer(gradientLayer!)
        
    }
    
}


extension EditProfileViewController: ProfileProtocol {
    
    
    func profileRetrieved() {
        
        // Update textfields
        nameTextField.text = currentProfile.name
        descTextField.text = currentProfile.bio
        
        // Update image
        guard currentProfile.profileImage != nil else { return }

        let url = URL(string: currentProfile.profileImage!)
        
        guard url != nil else { return }

        profileImageView.sd_setImage(with: url, completed: { (image, error, cacheType, url) in
            
            if error != nil {
                print("Error setting image from URL")
            }
            
            self.profileImageView.image = image
            
        })
        
        // Update social media textfields
        fbUsernameTextField.text = currentProfile.socialHandles?[Con.socialMedia.facebook]
        instaUsernameTextField.text = currentProfile.socialHandles?[Con.socialMedia.instagram]
        snapchatUsernameTextField.text = currentProfile.socialHandles?[Con.socialMedia.snapchat]
        tiktokUsernameTextField.text = currentProfile.socialHandles?[Con.socialMedia.tiktok]
        youtubeUsernameTextField.text = currentProfile.socialHandles?[Con.socialMedia.youtube]
        wechatUsernameTextField.text = currentProfile.socialHandles?[Con.socialMedia.wechat]
        
        // Use slider value to update gradient
        setGradient()
        
        // Update slider x position
        slider.value = currentProfile.border ?? 0.5
        
        
    }
    
    func setGradient() {
        
        // If its between 0 - 0.50
        // Caclulate ane show gradient between green and yellow
        var redTop:Float = 0.00
        var greenTop:Float = 0.00
        var blueTop:Float = 0.00
        
        var redBot:Float = 0.00
        var greenBot:Float = 0.00
        var blueBot:Float = 0.00
        
        guard currentProfile.border != nil else { return }
        
        if currentProfile.border! <= 0.5 {
            
            let multiplier = currentProfile.border! * 2
            // Top range
            redTop = (Con.Colors.green[0]+multiplier*Con.Colors.lowerRedDifference)
            greenTop = (Con.Colors.green[1]+multiplier*Con.Colors.lowerGreenDifference)
            blueTop = (Con.Colors.green[2]-multiplier*Con.Colors.lowerBlueDifference)
            
            // Bottom Range
            redBot = Con.Colors.yellow[0]
            greenBot = Con.Colors.yellow[1]
            blueBot = Con.Colors.yellow[2]
            
        } else {
            
            // Between yellow and orange
            let multiplier = (currentProfile.border! - 0.5) * 2
            // Top range
            redTop = (Con.Colors.yellow[0]+multiplier*Con.Colors.higherRedDifference)
            greenTop = (Con.Colors.yellow[1]-multiplier*Con.Colors.higherGreenDifference)
            blueTop = (Con.Colors.yellow[2]-multiplier*Con.Colors.higherBlueDifference)
            
            // Bottom Range
            redBot = Con.Colors.orange[0]
            greenBot = Con.Colors.orange[1]
            blueBot = Con.Colors.orange[2]
            
        }
        
        
        let colourTop = UIColor(red: CGFloat(redTop / 255.0), green: CGFloat(greenTop / 255.0), blue: CGFloat(blueTop / 255.0), alpha: 1).cgColor
        
        let colourBottom = UIColor(red: CGFloat(redBot / 255.0), green: CGFloat(greenBot / 255.0), blue: CGFloat(blueBot / 255.0), alpha: 1).cgColor
        
        
        
        gradientLayer!.colors = [colourTop, colourBottom]
        
        gradientLayer!.shouldRasterize = true
        
        borderImageView!.layer.addSublayer(gradientLayer!)

        
    }
    
    
    
}
