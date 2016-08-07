
//
//  MMConstants.swift
//  iMammoth for reddit
//
//  Created by KrishnaChaitanya Amjuri on 03/08/16.
//  Copyright © 2016 KrishnaChaitanya Amjuri. All rights reserved.
//

import UIKit

class MMConstants: NSObject {
    
    // Application default properties
    static let redirectURIScheme = "imammoth-for-reddit"
    static let redirectURI = "iMammoth-for-reddit://response"
    static let clientID = "FhboqVZdAcqDQA"
    
    // OAuth Scopes
    static let scopesArray = ["identity", "edit", "flair", "history", "modconfig", "modflair", "modlog", "modposts", "modwiki", "mysubreddits", "privatemessages", "read", "report", "save", "submit", "subscribe", "vote", "wikiedit", "wikiread"]
    
    // Keychain keys names
    static let MMAccessToken = "MMUserAccessToken"
    static let MMAppAccessToken = "MMAppAccessToken"
    static let MMRefreshToken = "MMRefreshToken"
    
    // Notification Names
    static let notification_receivedRedirectedURL = "receivedRedirectedURLNotification"
    static let notification_successfullyGotUserToken = "notification_successfullyGotUserToken"
}
