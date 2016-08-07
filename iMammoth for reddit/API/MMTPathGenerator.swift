//
//  iMPathGenerator.swift
//  iMammoth for reddit
//
//  Created by KrishnaChaitanya Amjuri on 22/05/16.
//  Copyright © 2016 KrishnaChaitanya Amjuri. All rights reserved.
//

import UIKit

var MM_CURRENT_STATE = "" // will get changed

enum MMProfile: String {
    case blocked    = "/blocked"
    case friends    = "/friends"
    case karma      = "/karma"
    case prefs      = "/prefs"
    case trophies   = "/trophies"
    case None       = ""
}

enum MMProfilePref: String {
    case friends    = "/friends"
    case blocked    = "/blocked"
}

class MMTPathGenerator: NSObject {
    
    static let BASE_TOKEN_URL = "https://www.reddit.com/api/v1"
    static let BASE_SERVER_URL = "https://oauth.reddit.com"
    
    //MARK: - TOKEN PATHS
    
    class func generateOfflineAccessTokenPath() -> String {
     
        return BASE_TOKEN_URL + "/access_token"
    }
    
    class func generateRefreshAccessTokenPath() -> String {
        
        return BASE_TOKEN_URL + "/access_token"
    }
    
    class func generateRevokeTokenPath() -> String {
        
        return BASE_TOKEN_URL + "/revoke_token"
    }
    
    class func generateImplicitGrantAuthorizationPath() -> String {
        
        let gigaPath:String = BASE_TOKEN_URL + "/authorize.compact?client_id=FhboqVZdAcqDQA&response_type=token&state=fuckyou&redirect_uri=iMammoth-for-reddit://response&scope=identity edit flair history modconfig modflair modlog modposts modwiki mysubreddits privatemessages read report save submit subscribe vote wikiedit wikiread"
        
        return gigaPath.getURLreadyString()
    }
    
    class func generateAuthorizationPath(scopes: [String]) -> String {
        
        var scopeString: String = "&scope="
        scopeString.appendContentsOf("\(scopes[0])")
        for i in 1...(scopes.count-1) {
            scopeString.appendContentsOf(",\(scopes[i])")
        }
        
        MM_CURRENT_STATE = String.getRandomAlphaNumericString(9)
        
        var path: String = BASE_TOKEN_URL + "/authorize.compact?client_id=\(MMConstants.clientID)&response_type=code&state=\(MM_CURRENT_STATE)&redirect_uri=\(MMConstants.redirectURI)&duration=permanent"
        path.appendContentsOf(scopeString)
        
        return path
    }
    
    //MARK: - ACCOUNT PATHS
    
    class func generateAccountAccessPath(forFilter filter: MMProfile) -> String {
        
        let path = BASE_SERVER_URL + "/api/v1/me" + filter.rawValue
        return path
    }
    
    class func generateAccountPrefAccessPath(forFilter filter: MMProfilePref) -> String {
        
        let path = MMTPathGenerator.generateAccountAccessPath(forFilter: .prefs) + filter.rawValue
        return path
    }
}
