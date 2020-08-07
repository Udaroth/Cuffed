//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    //MARK: Stylisation
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor(red: CGFloat(255 / 255.0), green: CGFloat(215 / 255.0), blue: CGFloat(97 / 255.0), alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
//        button.layer.sublayers?.forEach {$0.removeFromSuperlayer() }
        
        button.layer.borderWidth = 0
        
        button.layer.cornerRadius = button.frame.size.height/2.5
        button.tintColor = UIColor.white
        button.setTitleColor(.white, for: .normal)
        
        button.layer.masksToBounds = true
        
        // Add shadow layer and bring to front?
        
        let shadowLayer = UIView()
        shadowLayer.frame = button.frame
        shadowLayer.layer.shadowRadius = 10
        shadowLayer.layer.shadowOpacity = 0.3
        
        
        
        
        // Create gradient layer
        let gradientLayer = CAGradientLayer()

        gradientLayer.frame = button.bounds

        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)

        let colourTop = UIColor(red: CGFloat(253 / 255.0), green: CGFloat(103 / 255.0), blue: CGFloat(45 / 255.0), alpha: 1).cgColor

        let colourBottom = UIColor(red: CGFloat(255 / 255.0), green: CGFloat(215 / 255.0), blue: CGFloat(97 / 255.0), alpha: 1).cgColor

        gradientLayer.colors = [colourTop, colourBottom]

        gradientLayer.shouldRasterize = true

        button.layer.addSublayer(gradientLayer)
        
        
        button.addSubview(shadowLayer)
        
        // Filled rounded corner style
//        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        
    
        
    }
    
       static func styleFilledButtonGreen(_ button:UIButton) {
        
//            button.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        // Undo borders from Hollow Buttons
            button.layer.borderWidth = 0
            
            button.layer.cornerRadius = button.frame.size.height/2.5
            button.tintColor = UIColor.white
            
            button.layer.masksToBounds = true
            
            // Create gradient layer
            let gradientLayer = CAGradientLayer()

            gradientLayer.frame = button.bounds

            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)

            let colourTop = UIColor(red: CGFloat(2 / 255.0), green: CGFloat(193 / 255.0), blue: CGFloat(147 / 255.0), alpha: 1).cgColor

            let colourBottom = UIColor(red: CGFloat(232 / 255.0), green: CGFloat(241 / 255.0), blue: CGFloat(98 / 255.0), alpha: 1).cgColor

            gradientLayer.colors = [colourTop, colourBottom]

            gradientLayer.shouldRasterize = true

            button.layer.addSublayer(gradientLayer)
            
            
        }
    
    static func styleHollowButtonOrange(_ button:UIButton) {
        
//        button.layer.sublayers?.forEach {$0.removeFromSuperlayer() }
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(red: CGFloat(247 / 255.0), green: CGFloat(133 / 255.0), blue: CGFloat(67 / 255.0), alpha: 1).cgColor
        button.layer.cornerRadius = button.frame.size.height/2.5
        button.tintColor = UIColor(red: CGFloat(247 / 255.0), green: CGFloat(133 / 255.0), blue: CGFloat(67 / 255.0), alpha: 1)
//        button.backgroundColor = .white
        
    }
    
    static func styleHollowButtonGreen(_ button:UIButton) {
        
//        button.layer.sublayers?.forEach {$0.removeFromSuperlayer() }
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(red: CGFloat(173 / 255.0), green: CGFloat(247 / 255.0), blue: CGFloat(102 / 255.0), alpha: 1).cgColor
        button.layer.cornerRadius = button.frame.size.height/2.5
        button.tintColor = UIColor(red: CGFloat(173 / 255.0), green: CGFloat(247 / 255.0), blue: CGFloat(102 / 255.0), alpha: 1)
        
        
    }
    
    static func styleHollowButton(_ button:UIButton){
        
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = button.frame.size.height/2.5
        button.tintColor = UIColor.black
        
    }
    
    static func styleHollowImageViewOrange(_ image:UIImageView, name:UILabel, message:UILabel) {
        
        // Remove all sublayers before beginning

        image.layer.sublayers?.forEach{ $0.removeFromSuperlayer() }
        
        // Hollow rounded corner style
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: image.frame.size)

        gradient.colors = [Con.Colors.colorTopOrange, Con.Colors.colorBottomOrange]
        
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        let shape = CAShapeLayer()
        shape.lineWidth = 5
        image.layer.cornerRadius = image.frame.size.height/4
        shape.path = UIBezierPath(roundedRect: image.bounds, cornerRadius: image.layer.cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        image.layer.addSublayer(gradient)
        
        // Change label text colours
        
        name.textColor = .darkGray
        message.textColor = .lightGray
        
        
    }
    
    static func styleHollowImageViewGreen(_ image:UIImageView, name:UILabel, message:UILabel) {
        
        // Remove all sublayers before beginning

        image.layer.sublayers?.forEach{ $0.removeFromSuperlayer() }
        
        // Hollow rounded corner style
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: image.frame.size)

        gradient.colors = [Con.Colors.colorTopGreen, Con.Colors.colorBottomGreen]
        
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        let shape = CAShapeLayer()
        shape.lineWidth = 5
        image.layer.cornerRadius = image.frame.size.height/4
        shape.path = UIBezierPath(roundedRect: image.bounds, cornerRadius: image.layer.cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        image.layer.addSublayer(gradient)
        
        // Change label text colours
        
        name.textColor = .darkGray
        message.textColor = .lightGray
        
    }
    
    static func styleFilledImageViewOrange(_ image:UIImageView, name:UILabel?, message:UILabel?) {
        
        // Remove all sublayers before beginning

        image.layer.sublayers?.forEach{ $0.removeFromSuperlayer() }

        // Set Corner Radius
        image.layer.cornerRadius = image.frame.size.height/4
        
        image.layer.masksToBounds = true
        
        // Set gradient fill
        let gradientLayer = CAGradientLayer()

        gradientLayer.frame = image.bounds

        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)


        gradientLayer.colors = [Con.Colors.colorTopOrange, Con.Colors.colorBottomOrange]

        gradientLayer.shouldRasterize = true

        image.layer.addSublayer(gradientLayer)
        
        // Change label text colours
        
        if name != nil && message != nil {
            name!.textColor = .white
            message!.textColor = .white
            
        }
        

    }
    
    static func styleFilledImageViewGreen(_ image:UIImageView, name:UILabel, message:UILabel) {
        
        // Remove all sublayers before beginning

        image.layer.sublayers?.forEach{ $0.removeFromSuperlayer() }
        
        // Set Corner Radius
        image.layer.cornerRadius = image.frame.size.height/4
        
        image.layer.masksToBounds = true
        
        // Set gradient fill
        let gradientLayer = CAGradientLayer()

        gradientLayer.frame = image.bounds

        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)


        gradientLayer.colors = [Con.Colors.colorTopGreen, Con.Colors.colorBottomGreen]

        gradientLayer.shouldRasterize = true

        image.layer.addSublayer(gradientLayer)
        
        // Change label text colours
        
        name.textColor = .white
        message.textColor = .white
        
    }
    
    static func styleRecievedMessageCell(bubble:UIView, label:UILabel, isGreen:Bool){
        
        bubble.layer.sublayers?.forEach{ $0.removeFromSuperlayer() }
        
        bubble.layer.cornerRadius = bubble.frame.size.width/8
        bubble.tintColor = UIColor.white
        
        bubble.layer.masksToBounds = true
        
        // Create gradient layer
        let gradientLayer = CAGradientLayer()

        gradientLayer.frame = bubble.bounds

        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)

        gradientLayer.colors = [Con.Colors.colorTopGreen, Con.Colors.colorBottomGreen]

        gradientLayer.shouldRasterize = true

        bubble.layer.addSublayer(gradientLayer)
        
        label.textColor = .white
        
        
    }
    
    static func styleSentMessageCell(_ bubble:UIView,_ innerBackDrop: UIImageView, label:UILabel, isGreen:Bool){
        
        bubble.layer.sublayers?.forEach{ $0.removeFromSuperlayer() }
        
        if isGreen {
            // Is Green
            // MessageBubble
            
            let gradient = CAGradientLayer()
            gradient.frame = CGRect(origin: CGPoint.zero, size: bubble.frame.size)

            gradient.colors = [Con.Colors.colorTopGreen, Con.Colors.colorBottomGreen]
            
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 1)
            
            gradient.cornerRadius = bubble.frame.size.width/8
//
//            let shape = CAShapeLayer()
//            shape.lineWidth = 5
//            bubble.layer.cornerRadius = bubble.frame.size.width/8
//            shape.path = UIBezierPath(roundedRect: bubble.frame, cornerRadius: bubble.layer.cornerRadius).cgPath
//            shape.strokeColor = UIColor.black.cgColor
//            shape.fillColor = UIColor.clear.cgColor
//            gradient.mask = shape
            
            bubble.layer.addSublayer(gradient)
            
            
            // White back drop
            innerBackDrop.layer.cornerRadius = innerBackDrop.frame.size.width/8
            innerBackDrop.backgroundColor = .white
            
            // Text
            
            label.textColor = .darkGray
   
            
        } else {
            // Is Orange
            
            // MessageBubble
            
            let gradient = CAGradientLayer()
            gradient.frame = CGRect(origin: CGPoint.zero, size: bubble.frame.size)

            gradient.colors = [Con.Colors.colorTopOrange, Con.Colors.colorBottomOrange]
            
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 1)
            
            
            let shape = CAShapeLayer()
            shape.lineWidth = 5
            bubble.layer.cornerRadius = bubble.frame.size.width/8
            shape.path = UIBezierPath(roundedRect: bubble.bounds, cornerRadius: bubble.layer.cornerRadius).cgPath
            shape.strokeColor = UIColor.black.cgColor
            shape.fillColor = UIColor.clear.cgColor
            gradient.mask = shape
            
            bubble.layer.addSublayer(gradient)
            
            // Text
            label.textColor = UIColor(red: CGFloat(250 / 255.0), green: CGFloat(139 / 255.0), blue: CGFloat(8 / 255.0), alpha: 1)
            
            
        }
        
        
        
    }
    
    
    static func styleProfileIconBorder(_ image:UIImageView, border:Float, thickness:Int){
        
        // Hollow rounded corner style
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: image.frame.size)

        // Gradient Calculation Code
        // If its between 0 - 0.50
        // Caclulate ane show gradient between green and yellow
        var redTop:Float = 0.00
        var greenTop:Float = 0.00
        var blueTop:Float = 0.00
        var redBot:Float = 0.00
        var greenBot:Float = 0.00
        var blueBot:Float = 0.00
        
        if border <= 0.5 {
            let multiplier = border * 2
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
            let multiplier = (border - 0.5) * 2
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

        gradient.colors = [colourTop, colourBottom]
        
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        let shape = CAShapeLayer()
        shape.lineWidth = CGFloat(thickness)
        image.layer.cornerRadius = image.frame.size.height/2
        shape.path = UIBezierPath(roundedRect: image.bounds, cornerRadius: image.layer.cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        image.layer.addSublayer(gradient)
        
        
    }
    
    static func styleCrushCard(_ image:UIImageView,_ container:UIView) {
        
        let cornerRadius = CGFloat(20.00)
        
        // Set image gradient and corner radius
        let gradient = CAGradientLayer()
        gradient.frame = image.bounds

        gradient.colors = [Con.Colors.pinkTop, Con.Colors.pinkBot]

        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)

        image.layer.addSublayer(gradient)

        image.layer.cornerRadius = cornerRadius
    
        
        // Apply shadow to container view

        container.layer.shadowPath = UIBezierPath(roundedRect: image.bounds, cornerRadius: cornerRadius).cgPath
        container.layer.cornerRadius = cornerRadius
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOffset = CGSize(width: 0, height: 0)
        container.layer.shadowOpacity = 0.4
        container.layer.shadowRadius = 10
        

        
    }
    
    static func styleTalkCard(_ image:UIImageView,_ container:UIView) {
        
        let cornerRadius = CGFloat(20.00)
        
        let gradient = CAGradientLayer()
        gradient.frame = image.bounds

        gradient.colors = [Con.Colors.colorTopGreen, Con.Colors.colorBottomGreen]
        
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        image.layer.addSublayer(gradient)
        
        image.layer.cornerRadius = cornerRadius
        
        // Apply shadow to container view

        container.layer.shadowPath = UIBezierPath(roundedRect: image.bounds, cornerRadius: cornerRadius).cgPath
        container.layer.cornerRadius = cornerRadius
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOffset = CGSize(width: 0, height: 0)
        container.layer.shadowOpacity = 0.4
        container.layer.shadowRadius = 10
        
        
    }
    
    
    

    
    static func styleCardBackButton(_ button:UIButton, _ colourTop:CGColor,_ colourBottom:CGColor) {
            
    //        button.layer.sublayers?.forEach {$0.removeFromSuperlayer() }
            
            button.layer.borderWidth = 0
            
            button.layer.cornerRadius = button.frame.size.height/5
            button.tintColor = UIColor.white
//            button.setTitleColor(.white, for: .normal)
            
            button.layer.masksToBounds = true
            
            
            // Create gradient layer
            let gradientLayer = CAGradientLayer()

            gradientLayer.frame = button.bounds

            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)

            gradientLayer.colors = [colourTop, colourBottom]

            gradientLayer.shouldRasterize = true

            button.layer.addSublayer(gradientLayer)
            
            
        }
    
    // Round top corners for gray sheet
    static func roundTopCorners(view: UIView, corners:UIRectCorner, radius: CGFloat){
        
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
        
    }
    
    static func addWhiteBorder(_ image:UIImageView){
        
        let thickness = CGFloat(5)
        
        let shape = CAShapeLayer()
        shape.lineWidth = thickness
        image.layer.cornerRadius = image.frame.size.height/2
        shape.path = UIBezierPath(roundedRect: image.bounds, cornerRadius: image.layer.cornerRadius).cgPath
        shape.strokeColor = UIColor.white.cgColor
        shape.fillColor = UIColor.clear.cgColor
        
        image.layer.addSublayer(shape)
        
    }
    
    static func styleSearchBarView(_ view:UIView){
        
        let cornerRadius = CGFloat(10)
        
        view.layer.cornerRadius = cornerRadius
        
        view.layer.masksToBounds = true
        
        
    }
    
    // Add a drop shadow given the radius and opacity of the shadow
    static func addDropShadow(view:UIView, radius:CGFloat, opacity:Float){
        
        view.layer.shadowRadius = radius
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = .zero
        
    }
    
    // Add drop shadow, and round the corners
    static func addShadowCorners(image:UIView, container:UIView, shadowRadius:CGFloat, opacity:Float, cornerRadius:CGFloat){
                
        
            // Set image gradient and corner radius
//            let gradient = CAGradientLayer()
//            gradient.frame = image.bounds
//
//            gradient.colors = [Con.Colors.pinkTop, Con.Colors.pinkBot]
//
//            gradient.startPoint = CGPoint(x: 0, y: 0)
//            gradient.endPoint = CGPoint(x: 1, y: 1)
//
//            image.layer.addSublayer(gradient)

            image.layer.cornerRadius = cornerRadius
        
            
            // Apply shadow to container view

            container.layer.shadowPath = UIBezierPath(roundedRect: image.bounds, cornerRadius: cornerRadius).cgPath
            container.layer.cornerRadius = cornerRadius
//            container.layer.shadowColor = UIColor.black.cgColor
            container.layer.shadowOffset = .zero
            container.layer.shadowOpacity = opacity
            container.layer.shadowRadius = shadowRadius
        
        
    }
    
    static func fetchTime() -> String {
        
        let currentDate = Date()
        
        let since1970 = currentDate.timeIntervalSince1970
        
        return String(Int64(since1970 * 1000))
        
    }
    
    
    // MARK: Gradient Helpers
    static func calculateGradient(_ colour:Float,_ base:Float)->Float{
        
        
        // So the idea is we grab the colour, and we want to increment it by a certain constant
        // Towards the base colour
        
        var constant:Float = 0
        
        var newColour:Float = 0
        
        if colour < base {
            
            // If colour is of a lesser number
            // Then we want to add 20 to colour
            
            constant = (base - colour)/2
                
                
            newColour = colour + constant
            
            
        } else {
            
            // colour is larger than base
            // In this case we minus the constant from the colour
            constant = (colour - base)/2
            
            newColour = colour - constant
            
        }
        
        
        
        return newColour
    }
    
    
    
    
    
    
    //MARK: Validation
    
    
    static func validatePassword(_ password : String) -> Bool {
         
        
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
        
        
    }
    
    static func validateEmail(candidate: String) -> Bool {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    static func validateName(candidate: String) -> Bool {
        
        let nameRegex = "[a-zA-Z]{2,64}"
        
        return NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: candidate)
    }
    
    
}
