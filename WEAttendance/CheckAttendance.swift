//
//  CheckAttendance.swift
//  iAttendance
//
//  Created by shan on 10/22/17.
//  Copyright © 2017 Prasidha Timsina. All rights reserved.
//

import UIKit
var classchoose : String = ""
var classdisID : String = ""

class CheckAttendance: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var Classpick: UIPickerView!
    @IBOutlet weak var Loadindicator: UIActivityIndicatorView!
    override func viewDidLoad() {

        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent;
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool){
        Loadindicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.whiteLarge
        Loadindicator.center = view.center
        Loadindicator.hidesWhenStopped = true
        self.Loadindicator.startAnimating()
                self.Classpick.dataSource = self
                self.Classpick.delegate = self
        self.Loadindicator.stopAnimating()
        classchoose = classdis[0]
        classdisID = classID[0]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return classdis.count
    }
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        // Return a string from the array for this row.
        return classdis[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        print(classdis[row])
        classchoose = classdis[row]
        classdisID = classID[row]
        print(classdis[row])
        print(classdisID)
    }

}
