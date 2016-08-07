//
//  MMWebViewController.swift
//  iMammoth for reddit
//
//  Created by KrishnaChaitanya Amjuri on 02/08/16.
//  Copyright © 2016 KrishnaChaitanya Amjuri. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

class MMWebViewController: UIViewController, UIWebViewDelegate {

    var currentRequest: NSURLRequest?
    
    let progressBar: UIProgressView = UIProgressView(progressViewStyle: UIProgressViewStyle.Bar)

    required init(request: NSURLRequest) {
        super.init(nibName: nil, bundle: nil)
        currentRequest = request
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.dismissCurrent), name: MMConstants.notification_receivedRedirectedURL, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        let wbView: UIWebView = UIWebView(frame: UIScreen.mainScreen().bounds)
        wbView.delegate = self
        self.view = wbView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressBar.progressTintColor = UIColor.blueColor().colorWithAlphaComponent(1.0)
        progressBar.trackTintColor = UIColor.whiteColor().colorWithAlphaComponent(0.75)
        self.view.addSubview(progressBar)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(self.dismissCurrent))
        
        progressBar.snp_makeConstraints { (make) in
            make.left.equalTo(self.view.snp_left)
            make.right.equalTo(self.view.snp_right)
            make.height.equalTo(2.5)
            make.top.equalTo(self.view.snp_top).offset(66)
        }
        
        if let webview: UIWebView = self.view as? UIWebView {
            webview.loadRequest(currentRequest!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func dismissCurrent() {
        
        self.navigationController?.dismissViewControllerAnimated(true, completion: { 

        })
    }

    func webViewDidStartLoad(webView: UIWebView) {
        self.progressBar.setProgress(0.75, animated: true)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.progressBar.setProgress(1.0, animated: false)
        self.progressBar.hidden = true
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
