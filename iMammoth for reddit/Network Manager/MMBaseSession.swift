//
//  MMBaseSession.swift
//  iMammoth for reddit
//
//  Created by KrishnaChaitanya Amjuri on 02/08/16.
//  Copyright © 2016 KrishnaChaitanya Amjuri. All rights reserved.
//

import UIKit

class MMBaseManager: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate {
    
    static var sharedManager: MMBaseManager = MMBaseManager()
    
    override init() {
        super.init()
        
    }
    
}
