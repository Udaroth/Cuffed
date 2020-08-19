//
//  Animations.swift
//  Cuffed
//
//  Created by Evan Guan on 24/2/20.
//  Copyright © 2020 Evan Guan. All rights reserved.
//

import Foundation
import UIKit


class Animations {

    
    static func slideUpDetailCard(view:UIView, topCon:NSLayoutConstraint, botCon:NSLayoutConstraint){
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            
//            self.detailCardTableView.alpha = 1
            
            topCon.constant = 0
            botCon.constant = 100
            
            view.layoutIfNeeded()
            
        }, completion: nil)
        
        
    }
    
    static func hideDetailCard(view:UIView, topCon:NSLayoutConstraint, botCon:NSLayoutConstraint){
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            
            topCon.constant = 900
            botCon.constant = 1000
            
            view.layoutIfNeeded()
            
        }, completion: nil)
        
        
    }
    
    static func animateTouch(button:UIView){
        
        
        UIView.animate(withDuration: 0.1, animations: {
            
            button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        }) { (Bool) in
            
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                
                button.transform = CGAffineTransform(scaleX: 1, y: 1)
                
            }, completion: nil)
            
            
        }
        
    }
    
    static func animateHighlight(button:UIView){
        
//        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
//            button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//        }, completion: nil)
        
        UIView.animate(withDuration: 0.05) {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
        
    }
    
    static func animateUnhighlight(button:UIView){
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            button.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
        

        
    }
    
    
}
