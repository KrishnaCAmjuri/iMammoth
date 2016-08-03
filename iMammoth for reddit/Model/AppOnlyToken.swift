//
//  AppOnlyToken.swift
//  iMammoth for reddit
//
//  Created by KrishnaChaitanya Amjuri on 02/08/16.
//  Copyright © 2016 KrishnaChaitanya Amjuri. All rights reserved.
//

import UIKit
import ObjectMapper

class AppOnlyToken: Mappable {
    
    var accessToken: String = ""
    
    var expirationInterval: Int = 0
    
    var tokenType: String = ""
    
    required init?(_ map: Map) {
        if map.JSONDictionary["SUCCESS"] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        accessToken <- map["SUCCESS.access_token"]
        expirationInterval <- map["SUCCESS.expires_in"]
        tokenType <- map["SUCCESS.token_type"]
    }
}
