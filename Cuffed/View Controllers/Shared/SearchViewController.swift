//
//  SearchViewController.swift
//  Cuffed
//
//  Created by Evan Guan on 29/4/20.
//  Copyright © 2020 Evan Guan. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController {
    
    // IBOutlet variables

    @IBOutlet weak var searchBarView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var lightGrayView: UIView!
    
    @IBOutlet weak var searchTable: UITableView!
    
    @IBOutlet weak var searchLabel: UILabel!
    
    // Other variables
    
    // Firestore reference
    let fsRef = Firestore.firestore()
    
    // Variable to check whether we're running the latest query
    var latestFetch:String?
    
    // Document array that stores all table content
    var documents:[String:[QueryDocumentSnapshot]] = [:]
    
//    // Document array used to fetch query results
//    var standbyDocuments:[QueryDocumentSnapshot] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchTable.delegate = self
        searchTable.dataSource = self
        searchBar.delegate = self
        styleInterface()
        	
        searchBar.becomeFirstResponder()
        
    }
    
    func styleInterface(){
    
        // Set up searchbar
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.white
        }
        Utilities.styleSearchBarView(searchBarView)
        
        // 
        
        
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
    
        return documents.count
        

         
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Con.Cells.searchResultCell, for: indexPath) as! SearchResultTableViewCell
        
        cell.style(documents: documents, index: indexPath.row)
        
        cell.selectionStyle = .none
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // I think this function handles what happens when a cell is selected 
        
    }
    
}


extension SearchViewController: UISearchBarDelegate {
    
    // Function is called whenever the text in the search bar is updated
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                
        // Store the time of when this text edit occured
        let time = Utilities.fetchTime()
        
        // Grab the text in the search bar and put it all in lowercase
        let cleanedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        // Counter
        var counter = 0
        
        // Create an empty dictionary for queryDocumentSnapshots
        var documentDict:[String:[QueryDocumentSnapshot]] = [:]
        
        // If the cleanedText is not an empty string
        if cleanedText != "" {
            
            // Remove all items in the current documents array
//            var standbyDocuments:[QueryDocumentSnapshot] = []
            
            // Debugging statement
            print("Beginning fetch for \(cleanedText) at time \(time)")
            
            for item in Con.Firestore.IDArray {
                print("Checking for \(item)")
                
                // Perform firestore query into users for each social media id
                 fsRef.collection(Con.Firestore.users).whereField(item, isGreaterThanOrEqualTo: cleanedText).getDocuments { (snapshot, error) in
                     
                     if let error = error {
                         // An error has occured
                         print("Error fetching username documents \(error)")
                        
                     } else {
                         
                         // if latestFetch is nil that means no fetch has occured yet
                         // if time is later than latestFetch, this is a newer fetch, also continue
                         // Otherwise, we ignore this query
                         if self.latestFetch == nil || time >= self.latestFetch! {
                             
                             // Update latestFetch variable to the current query time
                            self.latestFetch = time
                            
                             // Set the value of the dictionary with given key, as the array of documents which has matched the criteria.
                            documentDict[item] = snapshot!.documents

                            // Only reload the table if this is the last iteration of the for loop
                            if counter == 5 {
                                // Reload table after all appending has occured
                                self.documents = documentDict
                                self.searchTable.reloadData()
                                
                            } else {
                                // Incremnet the counter for each social media incremented
                                counter += 1
                            }

                             
                         }
                         
                     }
                     
                 }
                
                
            }
            

 
        } else {
            // The text entered was an empty string
            // Remove all documents and reload the table
            print("Search bar is empty string at time \(time)")
            self.latestFetch = time
            self.documents.removeAll()
            self.searchTable.reloadData()
        }
    
        
    }
    
}
