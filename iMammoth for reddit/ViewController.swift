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
    
    let authorizationUrlString = "https://www.reddit.com/api/v1/authorize.compact?client_id=FhboqVZdAcqDQA&response_type=code&state=fuckyou&redirect_uri=iMammoth-for-reddit://response&duration=permanent&scope=identity,edit,flair,history,modconfig,modflair,modlog,modposts,modwiki,mysubreddits,privatemessages,read,report,save,submit,subscribe,vote,wikiedit,wikiread"
    
    let implicitGrantFlowAuthString = "https://www.reddit.com/api/v1/authorize.compact?client_id=FhboqVZdAcqDQA&response_type=token&state=fuckyou&redirect_uri=iMammoth-for-reddit://response&scope=identity edit flair history modconfig modflair modlog modposts modwiki mysubreddits privatemessages read report save submit subscribe vote wikiedit wikiread"
    
    func replaceSpaceByEncoding(string : String) -> String {
        if let returnS = string.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
            return returnS
        }
        return ""
    }
    
    func loginPressed(sender: AnyObject) {
        
        if let url: NSURL = NSURL(string: replaceSpaceByEncoding(implicitGrantFlowAuthString)) {
            let request: NSURLRequest = NSURLRequest(URL: url)
            let wkVC: MMWebViewController = MMWebViewController(request: request)
            let nav: UINavigationController = UINavigationController(rootViewController: wkVC)
            self.presentViewController(nav, animated: true, completion: nil)
//            webView.delegate = self
//            webView.loadRequest(request)
//            webView.hidden = false
//            login.hidden = true
        }
//
//        MMTClientAPIManager.generateClientOnlyAccessToken()
        
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        let activityindicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityindicator.tag = 22
        activityindicator.center = self.view.center
        activityindicator.hidesWhenStopped = true
        activityindicator.transform = CGAffineTransformMakeScale(2, 2)
        self.view.addSubview(activityindicator)
        
        activityindicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if let activityIndicator: UIActivityIndicatorView = self.view.viewWithTag(22) as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    let webView: UIWebView = UIWebView()
    let login: UIButton = UIButton(type: UIButtonType.Custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        webView.backgroundColor = UIColor.whiteColor()
        webView.hidden = true
        self.view.addSubview(webView)
        
        login.frame = CGRectMake(0, 0, 120, 40)
        login.center = self.view.center
        login.setTitle("Login", forState: UIControlState.Normal)
        login.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        login.backgroundColor = UIColor.lightGrayColor()
        login.addTarget(self, action: #selector(self.loginPressed(_:)), forControlEvents: UIControlEvents.TouchDown)
        self.view.addSubview(login)
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = self.view.bounds
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

