//
//  AddSpectrumViewController.swift
//  Cuffed
//
//  Created by Evan Guan on 20/12/19.
//  Copyright © 2019 Evan Guan. All rights reserved.
//

import UIKit
import Firebase

class AddSpectrumViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var ringImage: UIImageView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var spectrumImage: UIImageView!
    
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    var dbRef:DatabaseReference?
    
    var gradientLayer:CAGradientLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dbRef = Database.database().reference()
        
        stylise()
        
        fetchImage()
        
        createGradientLayer()
        
        styleInterface()
        
    }
    
    func styleInterface() {
        
        Utilities.styleHollowButton(skipButton)
        Utilities.styleFilledButton(saveButton)
        
    }
    
    func createGradientLayer() {
        
        gradientLayer = CAGradientLayer()
        
        guard gradientLayer != nil else { return }
        
        gradientLayer!.frame = ringImage.bounds
        
        gradientLayer!.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer!.endPoint = CGPoint(x: 1, y: 1)
        
    }
    
    func fetchImage() {
        
        guard let uid = Retrieve.retrieveUID() else { return }
        
        // Grab url of profile image
        dbRef?.child(Con.Database.users).child(uid).child(Con.Database.profileImage).observe(.value, with: { (snapshot) in
            
            // Check it is a string
            guard let urlString = snapshot.value as? String else { return }
            
            // Create Url object
            let url = URL(string: urlString)
            
            guard url != nil else { return }
            
            self.profileImage.sd_setImage(with: url) { (image, error, cacheType, url) in
                
                self.profileImage.image = image
                
            }
            
            
        })
    }
    
    func stylise(){
        
        ringImage.layer.cornerRadius = ringImage.frame.size.width/2
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        spectrumImage.layer.cornerRadius = 25
        
    }
    
    func uploadSlider() {
        
        // Grab UID
        let uid = Retrieve.retrieveUID()
        
        guard uid != nil else { return }
        
        dbRef?.child(Con.Database.users).child(uid!).child(Con.Database.border).setValue(slider.value)
        
    }
    
    
    @IBAction func backTapped(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        
        // Save current state of slider
        // We'll reproduce the gradients using code
        uploadSlider()
        
        // Next view controller
        performSegue(withIdentifier: Con.Segue.toAddSocial, sender: self)
        
        
    }
    
    @IBAction func skipTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: Con.Segue.toAddSocial, sender: self)
        
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        
        let sliderValue = slider.value
        
        updateRingImage(sliderValue: sliderValue)
        
//        print("Slider: \(sliderValue)%")
        
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
        
        ringImage!.layer.addSublayer(gradientLayer!)
        
    }
    
    
}
