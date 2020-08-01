//
//  SearchViewController.swift
//  Cuffed
//
//  Created by Evan Guan on 29/4/20.
//  Copyright © 2020 Evan Guan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBarView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var lightGrayView: UIView!
    
    @IBOutlet weak var searchTable: UITableView!
    
    @IBOutlet weak var searchLabel: UILabel!
    
    // Gem buttons
    @IBOutlet weak var fbButton: UIButton!
    
    @IBOutlet weak var instaButton: UIButton!
    
    @IBOutlet weak var snapchatButton: UIButton!
    
    @IBOutlet weak var tiktokButton: UIButton!
    
    @IBOutlet weak var youtubeButton: UIButton!
    
    @IBOutlet weak var wechatButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        searchTable.delegate = self
//        searchTable.dataSource = self
        styleInterface()
        
    }
    
    func styleInterface(){
    
        // Set up searchbar
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.white
        }
        Utilities.styleSearchBarView(searchBarView)
        
        // Dropshadow on the gems and the label
        
        Utilities.addDropShadow(view: fbButton, radius: 10, opacity: 0.5)
        
        
        // Corner radius and drop shadow for gray back
        
        
        
    
    }
    
    
    @IBAction func backTapped(_ sender: UIButton) {
        
        // Pop back into the previous view controller
        // Temporary solution
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            
            self.view.frame.origin.x = 400
            
            
        }) { (Bool) in
            self.dismiss(animated: false, completion: nil)
        }

        
        
    }
    

}


//extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//         
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//         
//    }
//    
//    
//    
//}
