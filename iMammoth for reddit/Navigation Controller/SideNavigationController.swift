//
//  SideNavigationController.swift
//  iMammoth for reddit
//
//  Created by KrishnaChaitanya Amjuri on 01/08/16.
//  Copyright © 2016 KrishnaChaitanya Amjuri. All rights reserved.
//

import UIKit

class SideNavigationController: UINavigationController {

    // Variables
    
    var leftMenu: UIViewController? {
        didSet {
            
        }
    }
    
    var rightMenu: UIViewController? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
