//
//  ViewController.swift
//  iMammoth for reddit
//
//  Created by KrishnaChaitanya Amjuri on 17/05/16.
//  Copyright © 2016 KrishnaChaitanya Amjuri. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UIWebViewDelegate {
    
    let implicitGrantFlowAuthString = "https://www.reddit.com/api/v1/authorize.compact?client_id=FhboqVZdAcqDQA&response_type=token&state=fuckyou&redirect_uri=iMammoth-for-reddit://response&scope=identity edit flair history modconfig modflair modlog modposts modwiki mysubreddits privatemessages read report save submit subscribe vote wikiedit wikiread"
    
    func replaceSpaceByEncoding(string : String) -> String {
        if let returnS = string.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
            return returnS
        }
        return ""
    }
    
    @IBAction func getUserToken(sender: AnyObject) {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(presentResultForNotification(_:)), name: MMConstants.notification_successfullyGotUserToken, object: nil)
        weak var weakself = self
        MMTokenManager.launchWebViewForUserOnlyAccessToken(weakself) { (success) in
            
        }
    }
    
    @IBAction func getRefreshToken(sender: AnyObject) {
        
        MMTokenManager.refreshTheAccessToken { (success) in
            dispatch_async(dispatch_get_main_queue(), {
                self.successAlert(success)
            })
        }
    }
    
    @IBAction func revokeCurrentToken(sender: AnyObject) {
        
        MMTokenManager.revokeToken { (success) in
            dispatch_async(dispatch_get_main_queue(), {
                self.successAlert(success)
            })
        }
    }
    
    @IBAction func getAppOnlyToken(sender: AnyObject) {
    
        MMTokenManager.generateClientOnlyAccessToken { (success) in
            dispatch_async(dispatch_get_main_queue(), { 
                self.successAlert(success)
            })
        }
    }
    
    @IBAction func getUserData(sender: AnyObject) {
        
        MMBaseSession.getUserData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func presentResultForNotification(sender: NSNotification) {
        
        var success: Bool = false
        if let userInfo: [String : NSNumber] = sender.userInfo as? [String : NSNumber] {
            success = (userInfo["success"]?.boolValue)!
        }
        self.successAlert(success)
    }
    
    func successAlert(success: Bool) {
        
        let alert: UIAlertController = UIAlertController(title: success ? "Successful" : "Failed", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let action: UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel) { (action) in
            
        }
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

