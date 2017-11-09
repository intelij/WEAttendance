//
//  DisplayAttendance.swift
//  WEAttendance
//
//  Created by shan on 11/1/17.
//  Copyright © 2017 Prasidha Timsina. All rights reserved.
//

import UIKit

class DisplayAttendance: UIViewController {
    
    
    
    @IBOutlet weak var ClassLabel: UILabel!
    override func viewDidLoad() {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
         ClassLabel.text =   "For " + classchoose
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

