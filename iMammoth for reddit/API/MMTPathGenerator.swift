//
//  iMPathGenerator.swift
//  iMammoth for reddit
//
//  Created by KrishnaChaitanya Amjuri on 22/05/16.
//  Copyright © 2016 KrishnaChaitanya Amjuri. All rights reserved.
//

import UIKit

let BASE_URL = "https://www.reddit.com/api/v1"

class MMTPathGenerator: NSObject {
    
    class func generateOfflineAccessTokenPath() -> String {
        return BASE_URL + "/access_token"
    }
    
    
}
