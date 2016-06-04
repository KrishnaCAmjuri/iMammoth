//
//  iRAPIManager.swift
//  iMammoth for reddit
//
//  Created by KrishnaChaitanya Amjuri on 22/05/16.
//  Copyright © 2016 KrishnaChaitanya Amjuri. All rights reserved.
//

import UIKit
import Alamofire

class iMApiManager: NSObject {
    
    override init() {
        super.init()
    }
    
    func generateClientOnlyAccessToken() -> String {

        let device_id = UIDevice.currentDevice().identifierForVendor!.UUIDString
        let parameters = ["grant_type":"https://oauth.reddit.com/grants/installed_client", "device_id":device_id]
        
        Alamofire.request(.POST, BASE_URL+"/access_token", parameters: parameters, encoding: ParameterEncoding.URLEncodedInURL, headers: nil).authenticate(user: "FhboqVZdAcqDQA", password: "client_secret").responseJSON { (response) in
            print("response: \(response)")
        }
        
        return ""
    }
    
    func redirectUserToWebPageForLogin() {
                
    }
}
