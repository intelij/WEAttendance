//
//  SendUnsentData.swift
//  iAttendance
//
//  Created by Prasidha 2/24/18
//  Copyright © 2017 Prasidha Timsina. All rights reserved.
//

import UIKit

class SendUnsentData: UIViewController {
    
    @IBAction func sendData(_ sender: UIButton) {
        let AD = AppDelegate()
        AD.SendUnSentData();
    }
    
    
    
   
    
    override func viewDidLoad() {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent;
        super.viewDidLoad()
        
        
    }
    
}

