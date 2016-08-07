//
//  NSMutableURLRequest+Auth.swift
//  iMammoth for reddit
//
//  Created by KrishnaChaitanya Amjuri on 04/08/16.
//  Copyright © 2016 KrishnaChaitanya Amjuri. All rights reserved.
//

import Foundation

protocol percentEncodedString {
    
    func getStringByAddingPercentEncoding() -> String
}

extension String : percentEncodedString {
    
    func getStringByAddingPercentEncoding() -> String {
        
        let charSet = NSCharacterSet.alphanumericCharacterSet()
        if let encodedString: String = self.stringByAddingPercentEncodingWithAllowedCharacters(charSet) {
            return encodedString
        }
        return self
    }
    
    func getURLreadyString() -> String {
        
        return self.stringByReplacingOccurrencesOfString(" ", withString: "%20")
    }
}

extension String {
    
    static func getRandomAlphaNumericString(length : Int) -> String {
        
        let allowedCharacters: String = "abcdefghijklmnopqrstuvwxyxABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        let count: UInt32 = UInt32(allowedCharacters.characters.count)
        var random: String = ""
        for _ in 0 ..< length {
            let index = arc4random_uniform(count)
            let char = allowedCharacters[allowedCharacters.startIndex.advancedBy(Int(index))]
            random.append(char)
        }
        return random
    }
}

extension Dictionary where Key : percentEncodedString, Value : percentEncodedString {
    
    func getEncodedPostData() -> NSData? {
        
        var parameter: [String] = []
        
        for (key, value) in self {
            parameter.append("\(key.getStringByAddingPercentEncoding())=\(value.getStringByAddingPercentEncoding())")
        }
        
        let parameterStr: String = parameter.joinWithSeparator("&")
        
        if let data: NSData = parameterStr.dataUsingEncoding(NSUTF8StringEncoding) {
            return data
        }
        
        return nil
    }
}

extension NSData {
    
    func getJSONObject() -> AnyObject? {
        
        do {
            let jsonstr = try NSJSONSerialization.JSONObjectWithData(self, options: NSJSONReadingOptions.MutableContainers)
            return jsonstr
        }catch {
            
        }
        
        return nil
    }
}

extension NSMutableURLRequest {
    
    func setBasicAuthentication(userName: String, _ password: String) -> Bool {
        
        let authenitcationChallenge = userName + ":" + password
        
        if let data = authenitcationChallenge.dataUsingEncoding(NSUTF8StringEncoding) {
            let base64Str = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
            self.setValue("Basic " + base64Str, forHTTPHeaderField: "Authorization")
            return true
        }
        
        return false
    }
    
    func configureForHTTPPost(parameters :[String : String]) {
        
        self.HTTPMethod = "POST"
        self.HTTPBody = parameters.getEncodedPostData()
    }
    
    func configureWithAuthenticationHeader() {
        
        MMTokenManager.loadToken(TokenType.User) { (token, success) in
            if success {
                self.addValue("bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        }
    }
    
}