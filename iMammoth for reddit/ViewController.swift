//
//  ViewController.swift
//  iMammoth for reddit
//
//  Created by KrishnaChaitanya Amjuri on 17/05/16.
//  Copyright © 2016 KrishnaChaitanya Amjuri. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let login: UIButton = UIButton(type: UIButtonType.Custom)
        login.setTitle("Login", forState: UIControlState.Normal)
        login.addTarget(self, action: #selector(self.loginClicked), forControlEvents: UIControlEvents.TouchDown)
        self.view.addSubview(login)
        
    }

    func loginClicked() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

