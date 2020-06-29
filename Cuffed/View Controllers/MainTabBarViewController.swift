//
//  MainTabBarViewController.swift
//  Cuffed
//
//  Created by Evan Guan on 24/12/19.
//  Copyright © 2019 Evan Guan. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarViewController: UITabBarController {
    
    let customTabBarView:UIView = {
        let view = UIView(frame: .zero)
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        
        
        // Shadow
        
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -8.0)
        
        view.layer.shadowOpacity = 0.12
        view.layer.shadowRadius = 10.0
        
        return view
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addCustomTabBarView()
        hideTabBarBorder()
        
        UITabBar.appearance().tintColor = UIColor(red: 32/255, green: 20/255, blue: 57/255, alpha: 1)
        
        authenticateUser()
        
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customTabBarView.frame = tabBar.frame.offsetBy(dx: 0, dy: -15)
        
        customTabBarView.frame.size = .init(width: customTabBarView.frame.width, height: customTabBarView.frame.height*2)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//
//        var newSafeArea = UIEdgeInsets()
//        
//        // Adjust the safe area to the height of the bottom view
//        newSafeArea.bottom += customTabBarView.bounds.size.height
//        
//        // Adust the safe area insets of the embedded child view controller
//        self.children.forEach({$0.additionalSafeAreaInsets = newSafeArea})
//        
//    }
    
    private func addCustomTabBarView(){
        
//        customTabBarView.frame = tabBar.frame.offsetBy(dx: 0, dy: -)
//        customTabBarView.frame.offsetBy(dx: 0, dy: 30)
//        customTabBarView.frame.size = .init(width: customTabBarView.frame.width, height: customTabBarView.frame.height*1.2)
        view.addSubview(customTabBarView)
        view.bringSubviewToFront(self.tabBar)

        
    }
    
    func hideTabBarBorder(){
        
        let tabBar = self.tabBar
        
        tabBar.backgroundImage = UIImage.from(color: .clear)
        
        tabBar.shadowImage = UIImage()
        
        tabBar.clipsToBounds = true
        
        
    }
    
    
    func authenticateUser() {
        
        
        
        
        if Auth.auth().currentUser == nil {
            
            DispatchQueue.main.async {
                
//                self.performSegue(withIdentifier: Con.Segue.noUserSegue, sender: self)
                
                // Instantiate new Tab View controller
                let loginVC = self.storyboard?.instantiateViewController(identifier: Con.Storyboard.NavigationController)
                
                self.view.window?.rootViewController = loginVC
                self.view.window?.makeKeyAndVisible()
                
//                let navController = UINavigationController(rootViewController: LandingViewController())
//
//                self.present(navController, animated: true, completion: nil)
                
            }
            
        } else {
            
            // User already exist
            print("User already logged in")
            
        }
        
        
    }
    


}


extension UIImage {
    
    static func from(color: UIColor) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        
        context!.fill(rect)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
        
        
        
    }
}
