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
        searchTable.delegate = self
        searchTable.dataSource = self
        styleInterface()
        
    }
    
    func styleInterface(){
    
        // Set up searchbar
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.white
        }
        Utilities.styleSearchBarView(searchBarView)
        
        // Dropshadow on the gems and the label
        
        Utilities.addDropShadow(view: fbButton, radius: 5, opacity: 0.2)
        Utilities.addDropShadow(view: instaButton, radius: 5, opacity: 0.2)
        Utilities.addDropShadow(view: snapchatButton, radius: 5, opacity: 0.2)
        Utilities.addDropShadow(view: wechatButton, radius: 5, opacity: 0.2)
        Utilities.addDropShadow(view: youtubeButton, radius: 5, opacity: 0.2)
        Utilities.addDropShadow(view: tiktokButton, radius: 5, opacity: 0.2)
        Utilities.addDropShadow(view: searchLabel, radius: 5, opacity: 0.2)
        
        
        // Corner radius and drop shadow for gray back
        Utilities.roundTopCorners(view: lightGrayView, corners: [.topLeft, .topRight], radius: 30)
        
        
        
    
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


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
         
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Con.Cells.searchResultCell, for: indexPath) as! SearchResultTableViewCell
        
        cell.style()
        
        cell.selectionStyle = .none
         
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // I think this function handles what happens when a cell is selected 
        
    }
    
}
