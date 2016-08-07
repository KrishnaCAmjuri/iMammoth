//
//  MMUserToken.swift
//  iMammoth for reddit
//
//  Created by KrishnaChaitanya Amjuri on 03/08/16.
//  Copyright © 2016 KrishnaChaitanya Amjuri. All rights reserved.
//

import UIKit
import ObjectMapper

class MMUserToken: Mappable {
    
    var accessToken: String = ""
    
    var expirationInterval: Int = 0
    
    var tokenType: String = ""
    
    var scope: String = ""
    
    var refreshToken: String = ""
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        accessToken <- map["access_token"]
        expirationInterval <- map["expires_in"]
        tokenType <- map["token_type"]
        scope <- map["scope"]
        refreshToken <- map["refresh_token"]
    }
}
