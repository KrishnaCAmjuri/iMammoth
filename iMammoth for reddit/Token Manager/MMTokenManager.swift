//
//  MMTokenManager.swift
//  iMammoth for reddit
//
//  Created by KrishnaChaitanya Amjuri on 03/08/16.
//  Copyright © 2016 KrishnaChaitanya Amjuri. All rights reserved.
//

import UIKit
import Keychain
import ObjectMapper

typealias tokenHandler = (Bool) -> Void
typealias tokenOutput = (String, Bool) ->  Void

enum TokenType {
    case User
    case Refresh
    case AppOnly
}

class MMTokenManager: NSObject {
    
    static func launchWebViewForUserOnlyAccessToken(forSelf: UIViewController?, completion: tokenHandler) {
        
        if let url: NSURL = NSURL(string: MMTPathGenerator.generateAuthorizationPath(MMConstants.scopesArray)) {
            
            let request = NSURLRequest(URL: url)
            let webView: MMWebViewController = MMWebViewController(request: request)
            let navVC: UINavigationController = UINavigationController(rootViewController: webView)
            
            if let hostVC: ViewController = forSelf as? ViewController {
                hostVC.presentViewController(navVC, animated: true, completion: {
                    completion(true)
                })
            }
        }else {
            
            completion(false)
        }
    }
    
    static func generateClientOnlyAccessToken(completion: tokenHandler) {
        
        var success: Bool = false
        
        let device_id = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let parameters = ["grant_type":"https://oauth.reddit.com/grants/installed_client", "device_id":device_id]
        
        if let url: NSURL = NSURL(string: MMTPathGenerator.generateOfflineAccessTokenPath()) {
            
            let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.configureForHTTPPost(parameters)
            request.setBasicAuthentication("FhboqVZdAcqDQA", "client_secret")
            
            let session:NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: nil)
            let uploadTask:NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                
                if error == nil {
                    if let jsonData:NSData = data {
                        if let ClientObj:MMClientToken = Mapper<MMClientToken>().map(jsonData.getJSONObject()) {
                            MMTokenManager.saveToken(ClientObj.accessToken, type: TokenType.AppOnly)
                            success = true
                        }
                    }
                }else {
                    
                }
                
                completion(success)
            })
            uploadTask.resume()
        }
    }

    static func getTokenFromRedirectedURL(url: NSURL, completion: tokenHandler) {
        
        var accessToken: String = ""
        var refreshToken: String = ""
        var successFullySentCodeRequest = false
        
        if url.scheme == MMConstants.redirectURIScheme {
           
            NSNotificationCenter.defaultCenter().postNotificationName(MMConstants.notification_receivedRedirectedURL, object: nil, userInfo: nil)
            
            if let components: NSURLComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: true) {
            
                if let query: String = components.query {
                
                    let queryParameters: NSArray = query.componentsSeparatedByString("&")
                    let codeParameters: NSArray = queryParameters.filteredArrayUsingPredicate(NSPredicate(format: "SELF BEGINSWITH %@", "code"))
                    let stateParameters: NSArray = queryParameters.filteredArrayUsingPredicate(NSPredicate(format: "SELF BEGINSWITH %@", "state"))
                    let code = codeParameters[0].stringByReplacingOccurrencesOfString("code=", withString: "")
                    let state = stateParameters[0].stringByReplacingOccurrencesOfString("state=", withString: "")
                    
                    if state == MM_CURRENT_STATE {
                        
                        if let url = NSURL(string: MMTPathGenerator.generateRefreshAccessTokenPath()) {
                            
                            successFullySentCodeRequest = true
                            
                            let parameters = ["grant_type" : "authorization_code", "code" : code, "redirect_uri" : MMConstants.redirectURI]

                            let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
                            request.configureForHTTPPost(parameters)
                            request.setBasicAuthentication(MMConstants.clientID, "client_secret")
                            
                            let session: NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
                            
                            let task: NSURLSessionTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                                
                                if error == nil {
                                    if let responseData = data {
                                        if let userObject: MMUserToken = Mapper<MMUserToken>().map(responseData.getJSONObject()) {
                                            accessToken = userObject.accessToken
                                            refreshToken = userObject.refreshToken
                                            Keychain.save(accessToken, forKey: MMConstants.MMAccessToken)
                                            Keychain.save(refreshToken, forKey: MMConstants.MMRefreshToken)
                                        }
                                    }
                                }
                                
                                completion((accessToken != "") && (refreshToken != ""))
                            })
                            
                            task.resume()
                        }
                    }
                }
            }
        }
        
        if !successFullySentCodeRequest {
            completion(false)
        }
    }
    
    static func revokeToken(completion: tokenHandler) {
        
        if let url = NSURL(string: MMTPathGenerator.generateRevokeTokenPath()) {
            
            MMTokenManager.loadToken(.Refresh, completion: { (token, success) in
                
                if success {
                    
                    let parameters = ["token":token, "token_type_hint":"refresh_token"]
                    let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
                    request.setBasicAuthentication(MMConstants.clientID, "client_secret")
                    request.configureForHTTPPost(parameters)
                    
                    let session: NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
                    
                    let task: NSURLSessionTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                        completion(true)
                    })
                    
                    task.resume()
                }
            })
        }
    }
    
    static func refreshTheAccessToken(completion: tokenHandler) {
        // not allowed for implicit grant flow
        if let url = NSURL(string: MMTPathGenerator.generateRefreshAccessTokenPath()) {
            
            MMTokenManager.loadToken(.Refresh, completion: { (refreshToken, success) in
                
                if success {
                
                    let parameters = ["grant_type":"refresh_token", "refresh_token":refreshToken]
                    
                    let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
                    request.setBasicAuthentication(MMConstants.clientID, "client_secret")
                    request.configureForHTTPPost(parameters)
                    
                    let session: NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
                    
                    let task: NSURLSessionTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                        
                        var accessToken = ""
                        
                        if error == nil {
                            if let jsonData:NSData = data {
                                if let client_Obj:MMClientToken = Mapper<MMClientToken>().map(jsonData.getJSONObject()) {
                                    accessToken = client_Obj.accessToken
                                }
                            }
                        }
                        
                        if accessToken != "" {
                            MMTokenManager.saveToken(accessToken, type: TokenType.User)
                        }
                        completion(accessToken != "")
                    })
                    
                    task.resume()
                }else {
                    
                }
            })
        }
    }
    
    static func saveToken(access_token: String, type: TokenType) {
       
        let key:String = (type == .User) ? MMConstants.MMAccessToken : ((type == .Refresh) ? MMConstants.MMRefreshToken : MMConstants.MMAppAccessToken)
        if Keychain.save(access_token, forKey: key) {
            
        }
    }
    
    static func loadToken(type: TokenType, completion: tokenOutput) {
       
        let key:String = (type == .User) ? MMConstants.MMAccessToken : ((type == .Refresh) ? MMConstants.MMRefreshToken : MMConstants.MMAppAccessToken)
        if let token = Keychain.load(key) {
            completion(token, true)
        }
        completion("", false)
    }
    
}
