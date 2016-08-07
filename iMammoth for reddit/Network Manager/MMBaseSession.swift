//
//  MMBaseSession.swift
//  iMammoth for reddit
//
//  Created by KrishnaChaitanya Amjuri on 02/08/16.
//  Copyright © 2016 KrishnaChaitanya Amjuri. All rights reserved.
//

import UIKit

class MMBaseSession: NSObject {
    
    static var sharedManager: MMBaseSession = MMBaseSession()
    
    override init() {
        super.init()
        
    }
    
    class func getUserData() {
        
        if let url:NSURL = NSURL(string: MMTPathGenerator.generateAccountPrefAccessPath(forFilter: MMProfilePref.friends)) {
            
            let request = NSMutableURLRequest(URL: url)
            request.configureWithAuthenticationHeader()
            
            let session:NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            
            let task:NSURLSessionTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                
                if let responseData: NSData = data {
                    let jsonObj = responseData.getJSONObject()
                    print("\(jsonObj!)")
                }
            })
            
            task.resume()
        }
    }
    
}
