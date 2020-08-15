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
    
    @IBOutlet weak var gemStackBGView: UIView!
    
    // Gem stack buttons
    
    @IBOutlet weak var fbGem: UIButton!
    
    @IBOutlet weak var inGem: UIButton!
    
    @IBOutlet weak var ttGem: UIButton!
    
    @IBOutlet weak var scGem: UIButton!
    
    @IBOutlet weak var wcGem: UIButton!
    
    @IBOutlet weak var ytGem: UIButton!
    
    // Gem Variables to help determine search fitler
    
    var searchingAll:Bool?
    
    var searchFilter:[String:Bool] = [:]
    
    // Firestore reference
    let fsRef = Firestore.firestore()
    
    // Variable to check whether we're running the latest query
    var latestFetch:String?
    
    // An array which holds all the query results
    var documents:[QueryResult] = []
    
    // String constants used in this ViewController
    
    struct localCons {
        
        static let all = "Searching all social media"
        
        static var mediaDict:[String:String] = [Con.Firestore.fbID:Con.socialMedia.facebook, Con.Firestore.inID:Con.socialMedia.instagram, Con.Firestore.scID:Con.socialMedia.snapchat, Con.Firestore.ttID:Con.socialMedia.tiktok, Con.Firestore.wcID:Con.socialMedia.wechat, Con.Firestore.ytID:Con.socialMedia.youtube]
        
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"

        // Do any additional setup after loading the view.
        searchTable.delegate = self
        searchTable.dataSource = self
        searchBar.delegate = self
        styleInterface()
        
        searchingAll = true
        
        searchFilter[Con.Firestore.fbID] = false
        searchFilter[Con.Firestore.inID] = false
        searchFilter[Con.Firestore.ttID] = false
        searchFilter[Con.Firestore.scID] = false
        searchFilter[Con.Firestore.wcID] = false
        searchFilter[Con.Firestore.ytID] = false
        
        	
        searchBar.becomeFirstResponder()
        
    }
    
    // Prepare for any seguing that happens
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // We need to give the next ViewController the UID of the user which we've just selected
        
        let indexPath = searchTable.indexPathForSelectedRow
        
        // Guard statement
        guard indexPath != nil else { return }
        
        // Store the tapped user id into cardUID
        let cardUID = (searchTable.cellForRow(at: indexPath!) as! SearchResultTableViewCell).UID
        
        // Get a reference to the detail view controller
        let cardVC = segue.destination as! DetailCardViewController
        
        // Update this card UID into the new controller
        cardVC.cardUID = cardUID
        
    }
    
    func styleInterface(){
    
        // Set up searchbar
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.white
        }
        Utilities.styleSearchBarView(searchBarView)
        
        // Style gemStack background
        gemStackBGView.layer.cornerRadius = 10
        
        // Add dropshadow to all the gems
        Utilities.addDropShadow(view: fbGem, radius: 3, opacity: 0.2)
        Utilities.addDropShadow(view: inGem, radius: 3, opacity: 0.2)
        Utilities.addDropShadow(view: ttGem, radius: 3, opacity: 0.2)
        Utilities.addDropShadow(view: scGem, radius: 3, opacity: 0.2)
        Utilities.addDropShadow(view: wcGem, radius: 3, opacity: 0.2)
        Utilities.addDropShadow(view: ytGem, radius: 3, opacity: 0.2)
        
        
        // Corner radius and drop shadow for gray back
        Utilities.roundTopCorners(view: lightGrayView, corners: [.topLeft, .topRight], radius: 30)
        
   
    
    }
    
    // Utilitie Function
    
    // Check the Boolean variables and update the search label accordingly
    func updateLabel(){
        
        // If we're currently searching all, then update the label
        if searchingAll! {
            searchLabel.text = localCons.all
        } else {
            // Otherwise, check through each item in the dictionary
            for media in searchFilter {
                // If we find that any of them are set to true, then
                if media.value {
                    // update the search label to the corresponding social media
                    searchLabel.text = "Searching in \(localCons.mediaDict[media.key] ?? "")"
                    break
                }
                
            }
            
        }
        
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
    
    
    // Gem buttons tapped
    
    @IBAction func fbTapped(_ sender: UIButton) {
        // Check status of the gems
        if !searchFilter[Con.Firestore.fbID]! {
            // If we are not searching for this gem exclusively
            // change the current search to be searching for this exclusively
            fbGem.setImage(UIImage(named: Con.socialMedia.facebook), for: .normal)
            // Set the rest to false
            searchingAll = false
            searchFilter[Con.Firestore.fbID] = true
            searchFilter[Con.Firestore.inID] = false
            searchFilter[Con.Firestore.scID] = false
            searchFilter[Con.Firestore.ttID] = false
            searchFilter[Con.Firestore.wcID] = false
            searchFilter[Con.Firestore.ytID] = false
            // Update the search label accordingly
            searchLabel.text = "Searching in Facebook"
            // Also trigger the DidEdit from search bar
            // Update the gem presentation
            // Set all gems not fb to placeholder gem
            if let image = UIImage(named: Con.Images.gemHolder) {
                ytGem.setImage(image, for: .normal)
                ttGem.setImage(image, for: .normal)
                wcGem.setImage(image, for: .normal)
                scGem.setImage(image, for: .normal)
                inGem.setImage(image, for: .normal)
            }
            
        } else {
            // This means that we were already searching fb
            // And the user wants to go back to searchingAll
            
            searchFilter[Con.Firestore.fbID] = false
            searchingAll = true
            
            // Update the label and gem status accordingly
            
            // Set all images back to normal
            fbGem.setImage(UIImage(named: Con.socialMedia.facebook), for: .normal)
            inGem.setImage(UIImage(named: Con.socialMedia.instagram), for: .normal)
            ttGem.setImage(UIImage(named: Con.socialMedia.tiktok), for: .normal)
            scGem.setImage(UIImage(named: Con.socialMedia.snapchat), for: .normal)
            wcGem.setImage(UIImage(named: Con.socialMedia.wechat), for: .normal)
            ytGem.setImage(UIImage(named: Con.socialMedia.youtube), for: .normal)
            
            searchLabel.text = localCons.all
            
        }
        
        searchBar(searchBar, textDidChange: searchBar.searchTextField.text!)

    }
    
    @IBAction func inTapped(_ sender: UIButton) {
        
        // Check status of the gems
        if !searchFilter[Con.Firestore.inID]! {
            // If we are not searching for this gem exclusively
            // change the current search to be searching for this exclusively
            inGem.setImage(UIImage(named: Con.socialMedia.instagram), for: .normal)
            // Set the rest to false
            searchingAll = false
            searchFilter[Con.Firestore.fbID] = false
            searchFilter[Con.Firestore.inID] = true
            searchFilter[Con.Firestore.scID] = false
            searchFilter[Con.Firestore.ttID] = false
            searchFilter[Con.Firestore.wcID] = false
            searchFilter[Con.Firestore.ytID] = false
            // Update the search label accordingly
            searchLabel.text = "Searching in Instagram"
            // Also trigger the DidEdit from search bar
            // Update the gem presentation
            // Set all gems not fb to placeholder gem
            if let image = UIImage(named: Con.Images.gemHolder) {
                ytGem.setImage(image, for: .normal)
                ttGem.setImage(image, for: .normal)
                wcGem.setImage(image, for: .normal)
                scGem.setImage(image, for: .normal)
                fbGem.setImage(image, for: .normal)
            }
            
        } else {
            // This means that we were already searching fb
            // And the user wants to go back to searchingAll
            
            searchFilter[Con.Firestore.inID] = false
            searchingAll = true
            
            // Update the label and gem status accordingly
            
            // Set all images back to normal
            fbGem.setImage(UIImage(named: Con.socialMedia.facebook), for: .normal)
            inGem.setImage(UIImage(named: Con.socialMedia.instagram), for: .normal)
            ttGem.setImage(UIImage(named: Con.socialMedia.tiktok), for: .normal)
            scGem.setImage(UIImage(named: Con.socialMedia.snapchat), for: .normal)
            wcGem.setImage(UIImage(named: Con.socialMedia.wechat), for: .normal)
            ytGem.setImage(UIImage(named: Con.socialMedia.youtube), for: .normal)
            
            searchLabel.text = localCons.all
            
        }
        
        searchBar(searchBar, textDidChange: searchBar.searchTextField.text!)
    }
    
    @IBAction func ttTapped(_ sender: UIButton) {
        
        // Check status of the gems
        if !searchFilter[Con.Firestore.ttID]! {
            // If we are not searching for this gem exclusively
            // change the current search to be searching for this exclusively
            ttGem.setImage(UIImage(named: Con.socialMedia.tiktok), for: .normal)
            // Set the rest to false
            searchingAll = false
            searchFilter[Con.Firestore.fbID] = false
            searchFilter[Con.Firestore.inID] = false
            searchFilter[Con.Firestore.scID] = false
            searchFilter[Con.Firestore.ttID] = true
            searchFilter[Con.Firestore.wcID] = false
            searchFilter[Con.Firestore.ytID] = false
            // Update the search label accordingly
            searchLabel.text = "Searching in TikTok"
            // Also trigger the DidEdit from search bar
            // Update the gem presentation
            // Set all gems not fb to placeholder gem
            if let image = UIImage(named: Con.Images.gemHolder) {
                ytGem.setImage(image, for: .normal)
                inGem.setImage(image, for: .normal)
                wcGem.setImage(image, for: .normal)
                scGem.setImage(image, for: .normal)
                fbGem.setImage(image, for: .normal)
            }
            
        } else {
            // This means that we were already searching fb
            // And the user wants to go back to searchingAll
            
            searchFilter[Con.Firestore.ttID] = false
            searchingAll = true
            
            // Update the label and gem status accordingly
            
            // Set all images back to normal
            fbGem.setImage(UIImage(named: Con.socialMedia.facebook), for: .normal)
            inGem.setImage(UIImage(named: Con.socialMedia.instagram), for: .normal)
            ttGem.setImage(UIImage(named: Con.socialMedia.tiktok), for: .normal)
            scGem.setImage(UIImage(named: Con.socialMedia.snapchat), for: .normal)
            wcGem.setImage(UIImage(named: Con.socialMedia.wechat), for: .normal)
            ytGem.setImage(UIImage(named: Con.socialMedia.youtube), for: .normal)
            
            searchLabel.text = localCons.all
            
        }
        
        searchBar(searchBar, textDidChange: searchBar.searchTextField.text!)
        
    }
    
    @IBAction func scTapped(_ sender: UIButton) {
        
        // Check status of the gems
        if !searchFilter[Con.Firestore.scID]! {
            // If we are not searching for this gem exclusively
            // change the current search to be searching for this exclusively
            scGem.setImage(UIImage(named: Con.socialMedia.snapchat), for: .normal)
            // Set the rest to false
            searchingAll = false
            searchFilter[Con.Firestore.fbID] = false
            searchFilter[Con.Firestore.inID] = false
            searchFilter[Con.Firestore.scID] = true
            searchFilter[Con.Firestore.ttID] = false
            searchFilter[Con.Firestore.wcID] = false
            searchFilter[Con.Firestore.ytID] = false
            // Update the search label accordingly
            searchLabel.text = "Searching in Snapchat"
            // Also trigger the DidEdit from search bar
            // Update the gem presentation
            // Set all gems not fb to placeholder gem
            if let image = UIImage(named: Con.Images.gemHolder) {
                ytGem.setImage(image, for: .normal)
                ttGem.setImage(image, for: .normal)
                wcGem.setImage(image, for: .normal)
                inGem.setImage(image, for: .normal)
                fbGem.setImage(image, for: .normal)
            }
            
        } else {
            // This means that we were already searching fb
            // And the user wants to go back to searchingAll
            
            searchFilter[Con.Firestore.scID] = false
            searchingAll = true
            
            // Update the label and gem status accordingly
            
            // Set all images back to normal
            fbGem.setImage(UIImage(named: Con.socialMedia.facebook), for: .normal)
            inGem.setImage(UIImage(named: Con.socialMedia.instagram), for: .normal)
            ttGem.setImage(UIImage(named: Con.socialMedia.tiktok), for: .normal)
            scGem.setImage(UIImage(named: Con.socialMedia.snapchat), for: .normal)
            wcGem.setImage(UIImage(named: Con.socialMedia.wechat), for: .normal)
            ytGem.setImage(UIImage(named: Con.socialMedia.youtube), for: .normal)
            
            searchLabel.text = localCons.all
            
        }
        
        searchBar(searchBar, textDidChange: searchBar.searchTextField.text!)
        
        
    }
    
    @IBAction func wcTapped(_ sender: UIButton) {
        
        // Check status of the gems
        if !searchFilter[Con.Firestore.wcID]! {
            // If we are not searching for this gem exclusively
            // change the current search to be searching for this exclusively
            wcGem.setImage(UIImage(named: Con.socialMedia.wechat), for: .normal)
            // Set the rest to false
            searchingAll = false
            searchFilter[Con.Firestore.fbID] = false
            searchFilter[Con.Firestore.inID] = false
            searchFilter[Con.Firestore.scID] = false
            searchFilter[Con.Firestore.ttID] = false
            searchFilter[Con.Firestore.wcID] = true
            searchFilter[Con.Firestore.ytID] = false
            // Update the search label accordingly
            searchLabel.text = "Searching in WeChat"
            print("Just updated search label")
            // Also trigger the DidEdit from search bar
            // Update the gem presentation
            // Set all gems not fb to placeholder gem
            if let image = UIImage(named: Con.Images.gemHolder) {
                ytGem.setImage(image, for: .normal)
                ttGem.setImage(image, for: .normal)
                inGem.setImage(image, for: .normal)
                scGem.setImage(image, for: .normal)
                fbGem.setImage(image, for: .normal)
            }
            
        } else {
            // This means that we were already searching fb
            // And the user wants to go back to searchingAll
            
            searchFilter[Con.Firestore.wcID] = false
            searchingAll = true
            
            // Update the label and gem status accordingly
            
            // Set all images back to normal
            fbGem.setImage(UIImage(named: Con.socialMedia.facebook), for: .normal)
            inGem.setImage(UIImage(named: Con.socialMedia.instagram), for: .normal)
            ttGem.setImage(UIImage(named: Con.socialMedia.tiktok), for: .normal)
            scGem.setImage(UIImage(named: Con.socialMedia.snapchat), for: .normal)
            wcGem.setImage(UIImage(named: Con.socialMedia.wechat), for: .normal)
            ytGem.setImage(UIImage(named: Con.socialMedia.youtube), for: .normal)
            
            searchLabel.text = localCons.all
            
        }
        
        searchBar(searchBar, textDidChange: searchBar.searchTextField.text!)
    }
    
    @IBAction func ytTapped(_ sender: UIButton) {
        
        // Check status of the gems
        if !searchFilter[Con.Firestore.ytID]! {
            // If we are not searching for this gem exclusively
            // change the current search to be searching for this exclusively
            ytGem.setImage(UIImage(named: Con.socialMedia.youtube), for: .normal)
            // Set the rest to false
            searchingAll = false
            searchFilter[Con.Firestore.fbID] = false
            searchFilter[Con.Firestore.inID] = false
            searchFilter[Con.Firestore.scID] = false
            searchFilter[Con.Firestore.ttID] = false
            searchFilter[Con.Firestore.wcID] = false
            searchFilter[Con.Firestore.ytID] = true
            // Update the search label accordingly
            searchLabel.text = "Searching in YouTube"
            // Also trigger the DidEdit from search bar
            // Update the gem presentation
            // Set all gems not fb to placeholder gem
            if let image = UIImage(named: Con.Images.gemHolder) {
                inGem.setImage(image, for: .normal)
                ttGem.setImage(image, for: .normal)
                wcGem.setImage(image, for: .normal)
                scGem.setImage(image, for: .normal)
                fbGem.setImage(image, for: .normal)
            }
            
        } else {
            // This means that we were already searching fb
            // And the user wants to go back to searchingAll
            
            searchFilter[Con.Firestore.ytID] = false
            searchingAll = true
            
            // Update the label and gem status accordingly
            
            // Set all images back to normal
            fbGem.setImage(UIImage(named: Con.socialMedia.facebook), for: .normal)
            inGem.setImage(UIImage(named: Con.socialMedia.instagram), for: .normal)
            ttGem.setImage(UIImage(named: Con.socialMedia.tiktok), for: .normal)
            scGem.setImage(UIImage(named: Con.socialMedia.snapchat), for: .normal)
            wcGem.setImage(UIImage(named: Con.socialMedia.wechat), for: .normal)
            ytGem.setImage(UIImage(named: Con.socialMedia.youtube), for: .normal)
            
            searchLabel.text = localCons.all
            
        }
        
        searchBar(searchBar, textDidChange: searchBar.searchTextField.text!)
    }
    
    
    
    

}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return documents.count
        

         
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Con.Cells.searchResultCell, for: indexPath) as! SearchResultTableViewCell
        
        cell.style(results: documents, index: indexPath.row)
        
//        cell.selectionStyle = .default
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // I think this function handles what happens when a cell is selected
        
        print("Cell selection detected at index \(indexPath.row)")
        
        // We should perform a segue to the detailCard view controller with the appropraite UID
        performSegue(withIdentifier: Con.Segue.searchToCard, sender: self)

        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        
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
        var standbyDocuments:[QueryResult] = []
        
        // If the cleanedText is not an empty string
        if cleanedText != "" {
            
            // Debugging statement
            print("Beginning fetch for \(cleanedText) at time \(time)")
            
            // Update label to show current search query
            updateLabel()
            
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
                            
                            // For each snapshot document result found, we'll turn them into a query result object
                            for doc in snapshot!.documents {
                                // Declare the result variable
                                let result = QueryResult()
                                // Set the document
                                result.document = doc
                                // Set the social media which it belonged in
                                result.socialMedia = item
                                
                                // Only append if the current gem / all search is active
                                if self.searchingAll! || (self.searchFilter[item] == true) {
                                    
                                    // Append it into the back of the standbyDocuments array
                                    standbyDocuments.append(result)
                                    
                                    
                                }
                            }
                            

                            // Only reload the table if this is the last iteration of the for loop
                            if counter == 5 {
                                // Reload table after all appending has occured
                                self.documents = standbyDocuments
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
            searchLabel.text = "Recent searches"
            self.latestFetch = time
            self.documents.removeAll()
            self.searchTable.reloadData()
        }
    
        
    }
    
}
