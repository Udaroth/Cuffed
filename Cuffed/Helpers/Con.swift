//
//  Con.swift
//  Cuffed
//
//  Created by Evan Guan on 15/12/19.
//  Copyright © 2019 Evan Guan. All rights reserved.
//

import Foundation
import UIKit

// Stores constants
class Con {
    
    struct coordinates {
        
        static let longConstant = 0.001131
        static let latConstant = 0.000915
        
    }
    
    struct buttonNames {
        static let uncrush = "Uncrush"
        static let crush = "Crush"
        static let tune = "Tune"
        static let untune = "Untune"
    }
    
    
    
    struct Settings {
        
        static let logOut = "Log Out"
        
        
    }
    
    struct Database {
        
        static let profileImage = "profileImage"
        static let users = "users"
        static let url = "url"
        static let name = "name"
        static let bio = "bio"
        static let border = "border"
        static let gems = "gems"
        static let social = "social"
        static let affinity = "affinity"
        static let extraImages = "extraImages"
        static let messages = "messages"
        static let convoCount = "convoCount"
        static let chatLog = "chatLog"
        static let recipients = "recipients"
        static let messageContent = "messageContent"
        static let senderUID = "senderUID"
        static let readStatus = "readStatus"
        static let timeStamps = "timeStamps"
        static let uid = "uid"
        
        static let infoArray = ["name", "bio", "border", "gems", "profileImage", "social"]
        
        static let yes = "yes"
        static let no = "no"
        
    }
    
    struct Firestore {
        static let users = "users"
        static let crush = "crush"
        static let tune = "tune"
        static let encounters = "encounters"
        static let long = "long"
        static let lat = "lat"
        static let uid = "uid"
        static let profileImage = "profileImage"
        static let timestamp = "timestamp"
        static let documentID = "documentID"
        static let border = "border"
        static let activeEncounters = "activeEncounters"
    
        
    }
    
    struct socialMedia {
        
        static let facebook = "Facebook"
        static let tiktok = "TikTok"
        static let wechat = "WeChat"
        static let snapchat = "Snapchat"
        static let youtube = "YouTube"
        static let instagram = "Instagram"
        
        static let smArray = ["Facebook", "TikTok", "WeChat", "Snapchat", "YouTube", "Instagram"]
        
        
    }
    
    struct Images{
        
        static let gemHolder = "Gemholders"
    }
    
    struct Colors {
        
        static let orange:[Float] = [237.0, 108.0, 111.0]
        static let yellow:[Float] = [240.0, 227.0, 69.0]
        static let green:[Float] = [129.0, 241.0, 146.0]
        
        // Between green and yellow
        static let lowerRedDifference = yellow[0] - green[0]
        static let lowerGreenDifference = green[1] - yellow[1]
        static let lowerBlueDifference = green[2] - yellow[2]

        // Between yellow and orange
        static let higherRedDifference = yellow[0] - orange[0]
        static let higherGreenDifference = yellow[1] - orange[1]
        static let higherBlueDifference = orange[2] - yellow[2]
        
        // Top and Bottom colours used for orange filled and hollow image views
        static let colorTopOrange = UIColor(red: CGFloat(250 / 255.0), green: CGFloat(139 / 255.0), blue: CGFloat(8 / 255.0), alpha: 1).cgColor
        static let colorBottomOrange = UIColor(red: CGFloat(244 / 255.0), green: CGFloat(127 / 255.0), blue: CGFloat(127 / 255.0), alpha: 1).cgColor
        
        // Top and Bot for pink filled views
        static let pinkTop = UIColor(red: CGFloat(235 / 255.0), green: CGFloat(81 / 255.0), blue: CGFloat(112 / 255.0), alpha: 1).cgColor
        static let pinkBot = UIColor(red: CGFloat(240 / 255.0), green: CGFloat(134 / 255.0), blue: CGFloat(110 / 255.0), alpha: 1).cgColor
        
        // Top and bottom colours used for green filled and hollow image views
        static let colorTopGreen = UIColor(red: CGFloat(91 / 255.0), green: CGFloat(255 / 255.0), blue: CGFloat(186 / 255.0), alpha: 1).cgColor
        static let colorBottomGreen = UIColor(red: CGFloat(170 / 255.0), green: CGFloat(225 / 255.0), blue: CGFloat(99 / 255.0), alpha: 1).cgColor
        
    }
    
    struct cardBackButtons {
        
        struct encounter {
            
            static let colourTop = UIColor(red: CGFloat(32 / 255.0), green: CGFloat(20 / 255.0), blue: CGFloat(57 / 255.0), alpha: 1).cgColor

            static let colourBottom = UIColor(red: CGFloat(40 / 255.0), green: CGFloat(34 / 255.0), blue: CGFloat(71 / 255.0), alpha: 1).cgColor
            
        }
        
        struct crush {
            
            static let colourTop = UIColor(red: CGFloat(235 / 255.0), green: CGFloat(81 / 255.0), blue: CGFloat(112 / 255.0), alpha: 1).cgColor

            static let colourBottom = UIColor(red: CGFloat(240 / 255.0), green: CGFloat(134 / 255.0), blue: CGFloat(119 / 255.0), alpha: 1).cgColor
            
        }
        
        struct ykc {
            
            static let colourTop = UIColor(red: CGFloat(91 / 255.0), green: CGFloat(255 / 255.0), blue: CGFloat(186 / 255.0), alpha: 1).cgColor

            static let colourBottom = UIColor(red: CGFloat(170 / 255.0), green: CGFloat(225 / 255.0), blue: CGFloat(99 / 255.0), alpha: 1).cgColor
            
        }
        
        struct follow {
            static let colourTop = UIColor(red: CGFloat(60 / 255.0), green: CGFloat(122 / 255.0), blue: CGFloat(216 / 255.0), alpha: 1).cgColor

            static let colourBottom = UIColor(red: CGFloat(83 / 255.0), green: CGFloat(193 / 255.0), blue: CGFloat(217 / 255.0), alpha: 1).cgColor
        }
        
        struct dm {
            static let colourTop = UIColor(red: CGFloat(255 / 255.0), green: CGFloat(138 / 255.0), blue: CGFloat(0 / 255.0), alpha: 1).cgColor

            static let colourBottom = UIColor(red: CGFloat(238 / 255.0), green: CGFloat(241 / 255.0), blue: CGFloat(79 / 255.0), alpha: 1).cgColor
            
            
        }
        
        struct hide {
            static let colourTop = UIColor(red: CGFloat(155 / 255.0), green: CGFloat(61 / 255.0), blue: CGFloat(170 / 255.0), alpha: 1).cgColor

            static let colourBottom = UIColor(red: CGFloat(116 / 255.0), green: CGFloat(45 / 255.0), blue: CGFloat(207 / 255.0), alpha: 1).cgColor
        }
        
        struct block {
            static let colourTop = UIColor(red: CGFloat(50 / 255.0), green: CGFloat(49 / 255.0), blue: CGFloat(79 / 255.0), alpha: 1).cgColor

            static let colourBottom = UIColor(red: CGFloat(52 / 255.0), green: CGFloat(74 / 255.0), blue: CGFloat(83 / 255.0), alpha: 1).cgColor
        }
        
        struct report {
            static let colourTop = UIColor(red: CGFloat(52 / 255.0), green: CGFloat(52 / 255.0), blue: CGFloat(52 / 255.0), alpha: 1).cgColor

            static let colourBottom = UIColor(red: CGFloat(101 / 255.0), green: CGFloat(101 / 255.0), blue: CGFloat(101 / 255.0), alpha: 1).cgColor
        }
        

        
        
    }

    
    struct Segue {
        
        static let toSetPassword = "toSetPassword"
        static let toCreateAccount = "toCreateAccount"
        static let toAddName = "toAddName"
        static let toAddBirth = "toAddBirth"
        static let toSetupComplete = "toSetupComplete"
        static let toCustomizeCard = "toCustomizeCard"
        static let toAddBio = "toAddBio"
        static let toSpectrum = "toSpectrum"
        static let toEditBio = "toEditBio"
        static let toSpectrum2 = "toSpectrum2"
        static let toAddSocial = "toAddSocial"
        static let toCardComplete = "toCardComplete"
        static let logOutSegue = "logOutSegue"
        static let noUserSegue = "noUserSegue"
        static let editProfileSeg = "editProfileSeg"
        static let toDetailMessages = "toDetailMessages"
        static let toFBCustomizeCard = "toFBCustomizeCard"
    }
    
    struct Account {
        
        static var email = ""
        static var password = ""
        static var name = ""
        static var birth = ""
        
    }
    
    struct Cells {
        
        static let profileCell = "ProfileCell"
        static let labelCell = "LabelCell"
        static let settingsCell = "SettingsOptionsCell"
        static let affinityCell = "AffiliationCollectionViewCell"
        static let addAffinityCell = "AddAffinityCollectionViewCell"
        static let imageCell = "ImageCollectionViewCell"
        static let addImageCell = "AddImageCollectionViewCell"
        static let messageCell = "MessageTableViewCell"
        static let sentCell = "SentMessageTableViewCell"
        static let receivedCell = "ReceivedMessageTableViewCell"
        static let talkCell = "TalkCollectionViewCell"
        static let searchResultCell = "SearchResultTableViewCell"
    }
    
    struct Storyboard {
        
        static let MainTabBarController = "MainTabBarController"
        static let NavigationController = "NavController"
        static let DetailCardViewController = "DetailCardViewController"
        
        
        static let encounterNavCont = "encounterNavCont"
        static let deckNavCont = "deckNavCont"
        static let messageNavCont = "messageNavCont"
        static let profileViewController = "profileViewController"
        static let searchNavCont = "searchNavCont"
        
        static let searchVC = "SearchViewController"
        
    }
    
    struct Names {
        
        static let myProfile = "My Profile"
        static let settings = "Settings"
    }
    
    static let settings = ["Notification", "Privacy", "Ads", "Security", "Account", "Help", "About", "Log Out"]
    
    
    static var photoURL = "https://scontent.fsyd7-1.fna.fbcdn.net/v/t1.0-9/66854894_2452856251438303_1219667104567918592_n.jpg?_nc_cat=100&_nc_ohc=qSWBFCSKnzkAQl0wodMK3U7bzhaBDC2CAh_bwQE3wMgeaHr8Wdz32FAGQ&_nc_ht=scontent.fsyd7-1.fna&oh=879aabca081689015b04cebc073ad98c&oe=5E829235"
    
}
